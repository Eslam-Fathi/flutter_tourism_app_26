// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceDetailsHash() => r'972041f2e64be74a10d0160fe7fd5c156ca3d52e';

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

/// See also [serviceDetails].
@ProviderFor(serviceDetails)
const serviceDetailsProvider = ServiceDetailsFamily();

/// See also [serviceDetails].
class ServiceDetailsFamily extends Family<AsyncValue<TourismService>> {
  /// See also [serviceDetails].
  const ServiceDetailsFamily();

  /// See also [serviceDetails].
  ServiceDetailsProvider call(String id) {
    return ServiceDetailsProvider(id);
  }

  @override
  ServiceDetailsProvider getProviderOverride(
    covariant ServiceDetailsProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serviceDetailsProvider';
}

/// See also [serviceDetails].
class ServiceDetailsProvider extends AutoDisposeFutureProvider<TourismService> {
  /// See also [serviceDetails].
  ServiceDetailsProvider(String id)
    : this._internal(
        (ref) => serviceDetails(ref as ServiceDetailsRef, id),
        from: serviceDetailsProvider,
        name: r'serviceDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$serviceDetailsHash,
        dependencies: ServiceDetailsFamily._dependencies,
        allTransitiveDependencies:
            ServiceDetailsFamily._allTransitiveDependencies,
        id: id,
      );

  ServiceDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<TourismService> Function(ServiceDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceDetailsProvider._internal(
        (ref) => create(ref as ServiceDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TourismService> createElement() {
    return _ServiceDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ServiceDetailsRef on AutoDisposeFutureProviderRef<TourismService> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ServiceDetailsProviderElement
    extends AutoDisposeFutureProviderElement<TourismService>
    with ServiceDetailsRef {
  _ServiceDetailsProviderElement(super.provider);

  @override
  String get id => (origin as ServiceDetailsProvider).id;
}

String _$companyServicesHash() => r'2a9ed3092329be9fd0872f59bd5c1fd1a9fed326';

/// See also [companyServices].
@ProviderFor(companyServices)
final companyServicesProvider =
    AutoDisposeFutureProvider<List<TourismService>>.internal(
      companyServices,
      name: r'companyServicesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$companyServicesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyServicesRef = AutoDisposeFutureProviderRef<List<TourismService>>;
String _$serviceNotifierHash() => r'6ca29e030b18d5659789cb25d6413c015498d628';

/// See also [ServiceNotifier].
@ProviderFor(ServiceNotifier)
final serviceNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ServiceNotifier,
      List<TourismService>
    >.internal(
      ServiceNotifier.new,
      name: r'serviceNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$serviceNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServiceNotifier = AutoDisposeAsyncNotifier<List<TourismService>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
