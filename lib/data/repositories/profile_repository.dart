import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProfileRepository {
  final SupabaseClient _supabase;

  SupabaseProfileRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  /// Fetches the avatar URL for a given user ID from the shadow profile table.
  Future<String?> getAvatarUrl(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('avatar_url')
          .eq('user_id', userId)
          .maybeSingle();

      return response?['avatar_url'] as String?;
    } catch (e) {
      // Return null if mapping doesn't exist or error occurs
      return null;
    }
  }

  /// Uploads an image to Supabase Storage and returns the public URL.
  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String extension,
  }) async {
    try {
      final fileName = '$userId.$extension';
      final filePath = 'avatars/$fileName';

      // Upload file to storage (bucket must be named 'avatars')
      await _supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Get public URL
      final avatarUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);

      // Save/Update mapping in the shadow profile table
      await _supabase.from('user_profiles').upsert({
        'user_id': userId,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      return avatarUrl;
    } catch (e) {
      throw 'Failed to upload avatar: $e';
    }
  }
}
