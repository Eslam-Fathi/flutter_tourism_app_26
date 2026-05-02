import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/models/user_model.dart';
import '../base/base_providers.dart';

part 'auth_provider.g.dart';

/// Represents the current authentication status of the user.
enum AuthStatus { 
  authenticated,    // User is logged in
  unauthenticated,  // User is not logged in
  guest,            // User is browsing without an account
  loading,          // Checking token status or performing login
  onboarding        // User is logged in but hasn't completed onboarding
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

  AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.errorMessage,
    this.isSubmitting = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
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
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final response = await ref.read(authRepositoryProvider).login(
            LoginRequest(email: email, password: password),
          );
      final user = await ref.read(authRepositoryProvider).getMe();
      if (user != null || response.user != null) {
        // Existing users skip onboarding — they already have an account.
        await _transitionToUser(user ?? response.user!, isNewUser: false);
      }
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Registers a new user and updates the app state.
  Future<void> register(String name, String email, String password, {String role = 'User'}) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final response = await ref.read(authRepositoryProvider).register(
            RegisterRequest(name: name, email: email, password: password, role: role),
          );
      final user = await ref.read(authRepositoryProvider).getMe();
      if (user != null || response.user != null) {
        // Brand-new users go through onboarding.
        await _transitionToUser(user ?? response.user!, isNewUser: true);
      }
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
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
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      // Step 1: Register the user account with 'Manager' role
      final response = await ref.read(authRepositoryProvider).register(
            RegisterRequest(name: name, email: email, password: password, role: 'Manager'),
          );
      final user = await ref.read(authRepositoryProvider).getMe();

      if (user == null && response.user == null) {
        state = state.copyWith(isSubmitting: false, errorMessage: 'Registration failed.');
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
      // Surface ALL errors — company creation failures included.
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
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
    if (!isNewUser) {
      // Persist so future logins are also instant.
      await storage.saveOnboardingStatus(user.id, true);
    }
    state = state.copyWith(
      status: hasOnboarded ? AuthStatus.authenticated : AuthStatus.onboarding,
      user: user,
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

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }
}
