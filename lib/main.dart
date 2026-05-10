/// {@template main}
/// # SeYaha Tourism App — Application Entry Point
///
/// This file serves as the **root of the Flutter widget tree** for the SeYaha
/// Tourism application.  It is responsible for:
///
/// 1. **Bootstrapping the Flutter engine** — `WidgetsFlutterBinding.ensureInitialized()`
///    must be called before any platform-channel code (e.g. secure storage, Supabase).
///
/// 2. **Loading environment variables** — The app uses `flutter_dotenv` to load a
///    `.env` file at runtime.  A graceful fallback ensures the app does not crash
///    if the file is absent (useful in CI/CD or demo deployments).
///
/// 3. **Initialising Supabase** — Only when valid credentials are present in the
///    environment.  Supabase is used as the **real-time avatar / shadow-profile
///    backend**; the primary REST API runs on a separate Node.js server.
///
/// 4. **Wrapping everything in a [ProviderScope]** — Required by `flutter_riverpod`
///    so that all [Provider]s and [Notifier]s can be read anywhere in the tree.
///
/// 5. **Auth-driven routing** — [MyApp._getHome] reads the [AuthState] from
///    [authNotifierProvider] and returns the correct root screen based on the
///    user's role and authentication status (see [AuthStatus]).
/// {@endtemplate}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tourism_app_26/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth/auth_provider.dart';
import 'presentation/providers/theme/theme_provider.dart';
import 'presentation/providers/theme/locale_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/splash_screen.dart';
import 'presentation/screens/auth/onboarding_screen.dart';
import 'presentation/screens/main_wrapper.dart';
import 'presentation/screens/admin/admin_main_wrapper.dart';
import 'presentation/screens/company/company_main_wrapper.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/network/supabase_config.dart';

/// The asynchronous application entry point.
///
/// Execution order:
/// ```
/// 1. ensureInitialized()     — bind Flutter engine before any async work
/// 2. dotenv.load()           — read secrets from the .env file
/// 3. SupabaseConfig.init()   — connect to Supabase (if credentials present)
/// 4. runApp(ProviderScope)   — start the widget tree inside a Riverpod scope
/// ```
///
/// **Why the nested try/catch blocks?**
/// Each initialisation step can fail independently.  Wrapping them separately
/// ensures a failure in `.env` loading does not block Supabase initialisation,
/// and vice-versa.  A fatal outer catch guards against completely unexpected
/// platform-level errors.
void main() async {
  try {
    // Step 1: Initialise the binding between the Flutter framework and the
    // underlying platform (required before any async native-channel calls).
    WidgetsFlutterBinding.ensureInitialized();

    // Step 2: Load .env if it exists, otherwise initialise with empty state
    // so that `dotenv.maybeGet(...)` calls return null rather than throwing.
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('Warning: Could not load .env file, initializing empty: $e');
      // Initialize with empty content to avoid "DotEnv has not been initialized" errors
      await dotenv.load(fileName: '');
    }

    // Step 3: Initialize Supabase only when credentials are available.
    // Supabase provides real-time avatar storage via its Storage bucket.
    // The primary REST API (Node.js / se-yaha.vercel.app) is separate.
    try {
      final url = dotenv.maybeGet('SUPABASE_URL') ?? '';
      final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';

      if (url.isNotEmpty && anonKey.isNotEmpty) {
        await SupabaseConfig.init();
      } else {
        debugPrint(
          'Warning: Supabase credentials are empty. Skipping initialization.',
        );
      }
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
    }
  } catch (e) {
    debugPrint('Fatal error during startup: $e');
  }

  // Step 4: Launch the widget tree.
  // [ProviderScope] is the Riverpod container — it MUST wrap the entire app so
  // that every ConsumerWidget / ref.watch() / ref.read() call resolves correctly.
  runApp(const ProviderScope(child: MyApp()));
}

/// The root application widget.
///
/// [MyApp] is a [ConsumerWidget] (from `flutter_riverpod`) so it can watch
/// state providers without needing a separate [StatefulWidget].
///
/// ### What it watches
/// | Provider                  | Purpose                                    |
/// |---------------------------|--------------------------------------------|
/// | [authNotifierProvider]    | Drives which home screen is displayed      |
/// | [themeNotifierProvider]   | Toggles between light / dark mode          |
/// | [localeNotifierProvider]  | Switches between English and Arabic (i18n) |
///
/// ### Localisation
/// The app supports **English** (`en`) and **Arabic** (`ar`).  Delegates are:
/// - [AppLocalizations.delegate] — app-specific string keys
/// - [GlobalMaterialLocalizations.delegate] — Material widget labels
/// - [GlobalWidgetsLocalizations.delegate] — directionality (LTR/RTL)
/// - [GlobalCupertinoLocalizations.delegate] — iOS-style widgets
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the three global state providers.  Every change to any of these
    // will cause MaterialApp to rebuild with the new value.
    final authState = ref.watch(authNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp(
      title: 'SeYaha Tourism',
      debugShowCheckedModeBanner: false,
      // Light and dark themes are defined centrally in AppTheme.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      // The home widget is determined dynamically based on auth status.
      home: _getHome(authState),
    );
  }

  /// Determines which root screen to show based on the current [AuthState].
  ///
  /// ### Routing logic
  /// ```
  /// AuthStatus.loading        → SplashScreen       (token check in progress)
  /// AuthStatus.onboarding     → OnboardingScreen   (new user first-launch)
  /// AuthStatus.unauthenticated → LoginScreen       (no session)
  /// AuthStatus.guest          → MainWrapper        (browsing without login)
  /// AuthStatus.authenticated  →
  ///   role == 'admin'         → AdminMainWrapper
  ///   role == 'company'/'manager' → CompanyMainWrapper
  ///   otherwise               → MainWrapper        (regular traveller / tour guide)
  /// ```
  ///
  /// Role comparison is case-insensitive (`toLowerCase()`) to guard against
  /// inconsistent capitalisation from the backend.
  Widget _getHome(AuthState state) {
    switch (state.status) {
      case AuthStatus.loading:
        // Show animated splash while AuthNotifier._init() checks the stored token.
        return const SplashScreen();
      case AuthStatus.authenticated:
        // Route to the role-specific wrapper so each role sees tailored navigation.
        if (state.user?.role.toLowerCase() == 'admin') {
          return const AdminMainWrapper();
        } else if (state.user?.role.toLowerCase() == 'company' ||
            state.user?.role.toLowerCase() == 'manager') {
          return const CompanyMainWrapper();
        }
        return const MainWrapper();
      case AuthStatus.guest:
        // Guests share the same MainWrapper but have limited access (no bookings).
        return const MainWrapper();
      case AuthStatus.onboarding:
        // First-time users are greeted with the onboarding flow.
        return const OnboardingScreen();
      case AuthStatus.unauthenticated:
        // No session — show the login/registration screen.
        return const LoginScreen();
    }
  }
}
