import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstracts all interaction with the device's encrypted key-value store.
///
/// ## Why Encrypted Storage?
/// JWTs are sensitive credentials — they grant full API access to the holder.
/// [FlutterSecureStorage] uses:
/// - **Android**: Android Keystore + AES encryption
/// - **iOS / macOS**: Keychain Services
/// - **Web**: `window.localStorage` (best-effort; Web has no true secure store)
///
/// Storing the token in plain `SharedPreferences` would expose it to any other
/// app or process with file-system access on a rooted/jailbroken device.
///
/// ## Keys
/// All keys are `static const` to prevent typos from causing hard-to-debug
/// cache misses.
///
/// | Key                          | Value                              |
/// |------------------------------|------------------------------------|
/// | `auth_token`                 | The current user's JWT             |
/// | `onboarded_<userId>`         | `"true"` if onboarding is done     |
///
/// ## Usage
/// ```dart
/// final storage = TokenStorage();
/// await storage.saveToken(jwt);               // persists the JWT
/// final token = await storage.getToken();     // null if not logged in
/// await storage.deleteToken();                // on logout
/// ```
class TokenStorage {
  /// The key under which the current user's JWT is stored.
  ///
  /// Changing this value in a release would log all existing users out because
  /// their stored token would no longer be found.
  static const _tokenKey = 'auth_token';

  /// The underlying encrypted storage instance.
  final FlutterSecureStorage _storage;

  /// Creates a [TokenStorage] backed by [FlutterSecureStorage].
  ///
  /// In tests, pass a fake [FlutterSecureStorage] in a constructor override
  /// or mock the class at a higher level via the Riverpod `overrideWithValue`.
  TokenStorage() : _storage = const FlutterSecureStorage();

  // ── Token Management ─────────────────────────────────────────────────────

  /// Persists [token] (a JWT string) to encrypted storage.
  ///
  /// If a token already exists, it is overwritten.  Call this immediately after
  /// a successful login or registration response.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Reads the stored JWT token.
  ///
  /// Returns `null` if no token has been saved (i.e., the user is logged out
  /// or has never logged in on this device).
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deletes the stored JWT token.
  ///
  /// Called during logout to ensure the user must re-authenticate on next
  /// app launch.  Does nothing if no token is stored.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ── Onboarding Status ────────────────────────────────────────────────────

  /// Persists whether [userId] has completed the onboarding flow.
  ///
  /// The key is scoped to [userId] so that switching accounts (unlikely but
  /// possible on shared devices) doesn't skip onboarding for a new user who
  /// shares the device with an existing one.
  ///
  /// [status] is serialised as the string `"true"` or `"false"` because
  /// [FlutterSecureStorage] only stores strings.
  Future<void> saveOnboardingStatus(String userId, bool status) async {
    await _storage.write(key: 'onboarded_$userId', value: status.toString());
  }

  /// Returns `true` if [userId] has completed the onboarding flow.
  ///
  /// Returns `false` (safe default) if no record is found — this ensures new
  /// users always see the onboarding flow rather than skipping it by mistake.
  Future<bool> getOnboardingStatus(String userId) async {
    final value = await _storage.read(key: 'onboarded_$userId');
    return value == 'true';
  }
}
