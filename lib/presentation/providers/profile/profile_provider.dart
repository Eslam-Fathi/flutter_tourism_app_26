import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/auth_provider.dart';
import '../base/base_providers.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery and uploads it to Supabase.
  Future<void> updateAvatar() async {
    final user = ref.read(authNotifierProvider).user;
    if (user == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
      );

      if (image == null) return;

      state = const AsyncValue.loading();

      final bytes = await image.readAsBytes();
      final extension = image.path.split('.').last;

      final repository = ref.read(profileRepositoryProvider);
      final avatarUrl = await repository.uploadAvatar(
        userId: user.id,
        bytes: bytes,
        extension: extension,
      );

      // Update the local auth state with the new avatar URL
      final authNotifier = ref.read(authNotifierProvider.notifier);
      authNotifier.updateLocalUser(user.copyWith(avatar: avatarUrl));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
