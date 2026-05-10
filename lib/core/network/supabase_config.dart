import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration helper for the Supabase backend integration.
///
/// ## Role of Supabase in SeYaha
/// SeYaha uses **two distinct backends**:
///
/// | Backend               | Purpose                                              |
/// |-----------------------|------------------------------------------------------|
/// | Node.js REST API      | Core data: users, services, bookings, companies      |
/// | Supabase (this class) | Shadow-profile storage: avatar images (Storage bucket) |
///
/// Supabase was chosen for avatar storage because it provides:
/// - An S3-compatible **Storage bucket** with CDN URLs
/// - Row-Level Security (RLS) to ensure each user can only access their own files
/// - A free tier generous enough for a startup-scale app
///
/// ## Environment variables (`.env`)
/// ```
/// SUPABASE_URL=https://<project-id>.supabase.co
/// SUPABASE_ANON_KEY=eyJ...
/// ```
///
/// These are read by `flutter_dotenv` at startup.  Never hardcode them.
///
/// ## Lifecycle
/// [init] must be called **once** during `main()`, before any widget is
/// rendered.  After that, the singleton [client] is safe to call from anywhere.
class SupabaseConfig {
  /// The Supabase project URL — loaded from `SUPABASE_URL` in the `.env` file.
  ///
  /// Returns an empty string if the variable is missing, which causes [init]
  /// to be skipped in `main()`.
  static String get url => dotenv.maybeGet('SUPABASE_URL') ?? '';

  /// The Supabase anonymous API key — loaded from `SUPABASE_ANON_KEY`.
  ///
  /// The **anon key** is safe to include in client-side code; it only grants
  /// access that is explicitly permitted by Supabase's Row-Level Security (RLS)
  /// policies.  It does NOT grant admin-level access.
  static String get anonKey => dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';

  /// Initialises the global Supabase singleton.
  ///
  /// Called once in `main()` after credentials are verified to be non-empty.
  /// After this call, [client] is available throughout the app lifetime.
  ///
  /// Throws a [StorageException] or [AuthException] if the credentials are
  /// malformed.  This is caught by the outer try/catch in `main()`.
  static Future<void> init() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  /// Returns the global [SupabaseClient] instance.
  ///
  /// This is the entry point for all Supabase operations:
  /// ```dart
  /// final storage = SupabaseConfig.client.storage;
  /// final ref = storage.from('avatars').getPublicUrl('path/to/file.jpg');
  /// ```
  ///
  /// Throws a [StateError] if [init] has not been called first.
  static SupabaseClient get client => Supabase.instance.client;
}
