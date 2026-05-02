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
    final data = await repo.getMyBookings();
    return data;
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
    // Note: If we are in company view, we might need to invalidate companyBookingsProvider
    // but the caller can handle that.
  }
}


@riverpod
Future<List<Booking>> companyBookings(CompanyBookingsRef ref) {
  return ref.read(bookingRepositoryProvider).getCompanyBookings();
}
