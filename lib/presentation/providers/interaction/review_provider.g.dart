// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewNotifierHash() => r'796d86996248b3725215b5b7711f4a6c47e9b5c9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ReviewNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Review>> {
  late final String serviceId;

  FutureOr<List<Review>> build(String serviceId);
}

/// See also [ReviewNotifier].
@ProviderFor(ReviewNotifier)
const reviewNotifierProvider = ReviewNotifierFamily();

/// See also [ReviewNotifier].
class ReviewNotifierFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [ReviewNotifier].
  const ReviewNotifierFamily();

  /// See also [ReviewNotifier].
  ReviewNotifierProvider call(String serviceId) {
    return ReviewNotifierProvider(serviceId);
  }

  @override
  ReviewNotifierProvider getProviderOverride(
    covariant ReviewNotifierProvider provider,
  ) {
    return call(provider.serviceId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reviewNotifierProvider';
}

/// See also [ReviewNotifier].
class ReviewNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ReviewNotifier, List<Review>> {
  /// See also [ReviewNotifier].
  ReviewNotifierProvider(String serviceId)
    : this._internal(
        () => ReviewNotifier()..serviceId = serviceId,
        from: reviewNotifierProvider,
        name: r'reviewNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$reviewNotifierHash,
        dependencies: ReviewNotifierFamily._dependencies,
        allTransitiveDependencies:
            ReviewNotifierFamily._allTransitiveDependencies,
        serviceId: serviceId,
      );

  ReviewNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  FutureOr<List<Review>> runNotifierBuild(covariant ReviewNotifier notifier) {
    return notifier.build(serviceId);
  }

  @override
  Override overrideWith(ReviewNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReviewNotifierProvider._internal(
        () => create()..serviceId = serviceId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ReviewNotifier, List<Review>>
  createElement() {
    return _ReviewNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReviewNotifierProvider && other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReviewNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Review>> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _ReviewNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ReviewNotifier, List<Review>>
    with ReviewNotifierRef {
  _ReviewNotifierProviderElement(super.provider);

  @override
  String get serviceId => (origin as ReviewNotifierProvider).serviceId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
