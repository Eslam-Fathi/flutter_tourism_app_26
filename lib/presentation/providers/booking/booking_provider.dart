import 'package:flutter_tourism_app_26/presentation/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/booking_model.dart';
import '../base/base_providers.dart';

part 'booking_provider.g.dart';

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  FutureOr<List<Booking>> build() async {
    return _fetchMyBookings();
  }

  Future<List<Booking>> _fetchMyBookings() async {
    final repo = ref.read(bookingRepositoryProvider);
    return await repo.getMyBookings();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchMyBookings());
  }

  Future<void> createBooking(Map<String, dynamic> data) async {
    final repo = ref.read(bookingRepositoryProvider);
    await repo.createBooking(data);
    await refresh();
  }

  Future<void> cancelBooking(String id) async {
    final repo = ref.read(bookingRepositoryProvider);
    await repo.cancelBooking(id);
    await refresh();
  }

  Future<void> confirmBooking(String id) async {
    final repo = ref.read(bookingRepositoryProvider);
    await repo.confirmBooking(id);
    await refresh();
  }

  Future<void> updateStatus(String id, String status) async {
    final repo = ref.read(bookingRepositoryProvider);
    await repo.updateBookingStatus(id, status);
    await refresh();
  }
}

@riverpod
Future<List<Booking>> companyBookings(CompanyBookingsRef ref) {
  return ref.read(bookingRepositoryProvider).getCompanyBookings();
}

@riverpod
Future<List<Booking>> allBookings(AllBookingsRef ref) {
  return ref.read(bookingRepositoryProvider).getAllBookings();
}
