import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/service_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/company_repository.dart';
import '../../../data/repositories/interaction_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/network/supabase_config.dart';
import '../../../data/repositories/article_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'base_providers.g.dart';

@Riverpod(keepAlive: true)
sb.SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return SupabaseConfig.client;
}

@Riverpod(keepAlive: true)
ArticleRepository articleRepository(ArticleRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ArticleRepository(supabase: supabase);
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(TokenStorageRef ref) {
  return TokenStorage();
}

@Riverpod(keepAlive: true)
DioClient dioClient(DioClientRef ref) {
  final storage = ref.watch(tokenStorageProvider);
  return DioClient(tokenStorage: storage);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  final storage = ref.watch(tokenStorageProvider);
  return AuthRepository(dio: client.instance, tokenStorage: storage);
}

@Riverpod(keepAlive: true)
ServiceRepository serviceRepository(ServiceRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return ServiceRepository(dio: client.instance);
}

@Riverpod(keepAlive: true)
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return BookingRepository(dio: client.instance);
}

@Riverpod(keepAlive: true)
CompanyRepository companyRepository(CompanyRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return CompanyRepository(dio: client.instance);
}

@Riverpod(keepAlive: true)
InteractionRepository interactionRepository(InteractionRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return InteractionRepository(dio: client.instance);
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return ChatRepository(dio: client.instance);
}

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) {
  final client = ref.watch(dioClientProvider);
  return UserRepository(dio: client.instance);
}
