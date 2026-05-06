import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/models/user_model.dart';
import '../base/base_providers.dart';

part 'auth_provider.g.dart';

/// Represents the current authentication status of the user.
enum AuthStatus {
  authenticated, // User is logged in
  unauthenticated, // User is not logged in
  guest, // User is browsing without an account
  loading, // Checking token status or performing login
  onboarding, // User is logged in but hasn't completed onboarding
}

/// State object for the AuthNotifier.
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  /// True only while a login/register network call is in flight.
  /// Used by the login button to show an inline spinner without
  /// triggering the full-screen loading scaffold in main.dart.
  final bool isSubmitting;

  /// Timestamp until which the user is locked out due to too many failed attempts.
  final DateTime? lockoutUntil;

  AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.errorMessage,
    this.isSubmitting = false,
    this.lockoutUntil,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isSubmitting,
    DateTime? lockoutUntil,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
    );
  }
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _init();
    return AuthState();
  }

  Future<void> _init() async {
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.getToken();

    if (token == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    try {
      final user = await ref.read(authRepositoryProvider).getMe();
      if (user != null) {
        await _transitionToUser(user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Logs in the user and updates the app state.
  /// Uses [isSubmitting] instead of AuthStatus.loading to keep the
  /// login button spinner local — no full-screen loading scaffold.
  Future<void> login(String email, String password) async {
    if (_isLockedOut()) return;
    
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .login(LoginRequest(email: email, password: password));
      final user = await ref.read(authRepositoryProvider).getMe();
      if (user != null || response.user != null) {
        // Existing users skip onboarding — they already have an account.
        await _transitionToUser(user ?? response.user!, isNewUser: false);
      }
    } catch (e) {
      _handleAuthError(e);
    }
  }

  /// Registers a new user and updates the app state.
  Future<void> register(
    String name,
    String email,
    String password, {
    String role = 'User',
  }) async {
    if (_isLockedOut()) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final response = await ref
          .read(authRepositoryProvider)
          .register(
            RegisterRequest(
              name: name,
              email: email,
              password: password,
              role: role,
            ),
          );
      final user = await ref.read(authRepositoryProvider).getMe();
      if (user != null || response.user != null) {
        // Brand-new users go through onboarding.
        await _transitionToUser(user ?? response.user!, isNewUser: true);
      }
    } catch (e) {
      _handleAuthError(e);
    }
  }

  /// Registers a new user AND creates a company profile in one step.
  /// Step 1: Register as a Manager role.
  /// Step 2: Call POST /api/companies to create the company profile.
  /// The company will be pending admin approval.
  Future<void> registerAsCompany(
    String name,
    String email,
    String password,
    String companyName,
    String companyDescription,
    String companyCategory,
    String? address,
    String? phone,
  ) async {
    if (_isLockedOut()) return;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      // Step 1: Register the user account with 'Manager' role
      final response = await ref
          .read(authRepositoryProvider)
          .register(
            RegisterRequest(
              name: name,
              email: email,
              password: password,
              role: 'Manager',
            ),
          );
      final user = await ref.read(authRepositoryProvider).getMe();

      if (user == null && response.user == null) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed.',
        );
        return;
      }

      // Step 2: Create the company profile (token is now stored from registration)
      // NOTE: This call uses the token just obtained, so it runs as the new manager.
      await ref.read(companyRepositoryProvider).createCompany({
        'name': companyName,
        'description': companyDescription,
        'category': companyCategory,
        if (address != null && address.isNotEmpty) 'address': address,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      });

      // Transition to the app — company is pending admin approval
      await _transitionToUser(user ?? response.user!, isNewUser: true);
    } catch (e) {
      _handleAuthError(e);
    }
  }

  bool _isLockedOut() {
    if (state.lockoutUntil != null && state.lockoutUntil!.isAfter(DateTime.now())) {
      final wait = state.lockoutUntil!.difference(DateTime.now()).inMinutes;
      state = state.copyWith(
        errorMessage: 'Too many attempts. Locked out for ${wait + 1} minutes.',
      );
      return true;
    }
    return false;
  }

  void _handleAuthError(dynamic e) {
    if (e is DioException && (e.response?.statusCode == 429 || e.error.toString().contains('Too many attempts'))) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.error.toString().contains('Too many attempts') ? e.error.toString() : 'Too many attempts. Please try again in 15 minutes.',
        lockoutUntil: DateTime.now().add(const Duration(minutes: 15)),
      );
    } else {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
    }
  }

  /// Sets the state to Guest, allowing limited access without a token.
  void continueAsGuest() {
    state = state.copyWith(status: AuthStatus.guest);
  }

  Future<void> _transitionToUser(User user, {bool isNewUser = false}) async {
    final storage = ref.read(tokenStorageProvider);
    // For existing users logging in, always treat them as onboarded so they
    // never see the onboarding screen again regardless of local storage.
    final hasOnboarded = isNewUser
        ? await storage.getOnboardingStatus(user.id)
        : true;
    // Persist so future logins are also instant.
    if (!isNewUser) {
      await storage.saveOnboardingStatus(user.id, true);
    }

    // --- FETCH SHADOW PROFILE (AVATAR) FROM SUPABASE ---
    String? supabaseAvatar;
    try {
      supabaseAvatar = await ref.read(profileRepositoryProvider).getAvatarUrl(user.id);
    } catch (_) {
      // Ignore errors fetching shadow profile
    }

    state = state.copyWith(
      status: hasOnboarded ? AuthStatus.authenticated : AuthStatus.onboarding,
      user: user.copyWith(avatar: supabaseAvatar ?? user.avatar),
      isSubmitting: false,
    );
  }

  Future<void> completeOnboarding() async {
    if (state.user != null) {
      final storage = ref.read(tokenStorageProvider);
      await storage.saveOnboardingStatus(state.user!.id, true);
      state = state.copyWith(status: AuthStatus.authenticated);
    }
  }

  void updateLocalUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }
}
