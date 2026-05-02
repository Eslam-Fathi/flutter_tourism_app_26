import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/user_model.dart';
import '../base/base_providers.dart';

part 'user_management_provider.g.dart';

@riverpod
class UserManagementNotifier extends _$UserManagementNotifier {
  @override
  FutureOr<List<User>> build() async {
    final repo = ref.read(userRepositoryProvider);
    return await repo.getAllUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).getAllUsers());
  }

  Future<void> deleteUser(String id) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.deleteUser(id);
    await refresh();
  }
}

@riverpod
List<User> filteredUsers(FilteredUsersRef ref, String query) {
  final usersAsync = ref.watch(userManagementNotifierProvider);
  
  return usersAsync.when(
    data: (users) {
      if (query.isEmpty) return users;
      final lowercaseQuery = query.toLowerCase();
      return users.where((user) {
        return user.name.toLowerCase().contains(lowercaseQuery) ||
               user.email.toLowerCase().contains(lowercaseQuery) ||
               user.role.toLowerCase().contains(lowercaseQuery);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}
