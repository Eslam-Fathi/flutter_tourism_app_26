import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/utils/placeholder_data.dart';
import '../base/base_providers.dart';

part 'booking_provider.g.dart';

@riverpod
class BookingNotifier extends _$BookingNotifier {
  @override
  FutureOr<List<Booking>> build() async {
    return _fetchMyBookings();
  }

  Future<List<Booking>> _fetchMyBookings() async {
    try {
      final repo = ref.read(bookingRepositoryProvider);
      final data = await repo.getMyBookings();
      if (data.isEmpty) return PlaceholderData.mockBookings;
      return data;
    } catch (e) {
      return PlaceholderData.mockBookings;
    }
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
}
