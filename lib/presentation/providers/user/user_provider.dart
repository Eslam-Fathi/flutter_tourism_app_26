import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/user_model.dart';
import '../base/base_providers.dart';

part 'user_provider.g.dart';

@riverpod
Future<List<User>> tourGuides(TourGuidesRef ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getTourGuides();
}

@riverpod
Future<User?> userById(UserByIdRef ref, String id) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getUserById(id);
}
