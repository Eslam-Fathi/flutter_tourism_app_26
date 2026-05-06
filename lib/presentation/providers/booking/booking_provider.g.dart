// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companyBookingsHash() => r'd4b65da446b99c6c97117e4d23e0ef435bb2a582';

/// See also [companyBookings].
@ProviderFor(companyBookings)
final companyBookingsProvider =
    AutoDisposeFutureProvider<List<Booking>>.internal(
      companyBookings,
      name: r'companyBookingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$companyBookingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyBookingsRef = AutoDisposeFutureProviderRef<List<Booking>>;
String _$allBookingsHash() => r'4ab3312dc1875d4c56f95b548d4f0f663081497c';

/// See also [allBookings].
@ProviderFor(allBookings)
final allBookingsProvider = AutoDisposeFutureProvider<List<Booking>>.internal(
  allBookings,
  name: r'allBookingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allBookingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllBookingsRef = AutoDisposeFutureProviderRef<List<Booking>>;
String _$bookingNotifierHash() => r'7dd1e93a641e556c0234c9cb20d923e583f119d2';

/// See also [BookingNotifier].
@ProviderFor(BookingNotifier)
final bookingNotifierProvider =
    AutoDisposeAsyncNotifierProvider<BookingNotifier, List<Booking>>.internal(
      BookingNotifier.new,
      name: r'bookingNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookingNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BookingNotifier = AutoDisposeAsyncNotifier<List<Booking>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
