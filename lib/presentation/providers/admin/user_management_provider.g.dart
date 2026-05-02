// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredUsersHash() => r'e3f81905c5b5081b45a594ce06d3485ca39505af';

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

/// See also [filteredUsers].
@ProviderFor(filteredUsers)
const filteredUsersProvider = FilteredUsersFamily();

/// See also [filteredUsers].
class FilteredUsersFamily extends Family<List<User>> {
  /// See also [filteredUsers].
  const FilteredUsersFamily();

  /// See also [filteredUsers].
  FilteredUsersProvider call(String query) {
    return FilteredUsersProvider(query);
  }

  @override
  FilteredUsersProvider getProviderOverride(
    covariant FilteredUsersProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredUsersProvider';
}

/// See also [filteredUsers].
class FilteredUsersProvider extends AutoDisposeProvider<List<User>> {
  /// See also [filteredUsers].
  FilteredUsersProvider(String query)
    : this._internal(
        (ref) => filteredUsers(ref as FilteredUsersRef, query),
        from: filteredUsersProvider,
        name: r'filteredUsersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$filteredUsersHash,
        dependencies: FilteredUsersFamily._dependencies,
        allTransitiveDependencies:
            FilteredUsersFamily._allTransitiveDependencies,
        query: query,
      );

  FilteredUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(List<User> Function(FilteredUsersRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: FilteredUsersProvider._internal(
        (ref) => create(ref as FilteredUsersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<User>> createElement() {
    return _FilteredUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredUsersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredUsersRef on AutoDisposeProviderRef<List<User>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _FilteredUsersProviderElement
    extends AutoDisposeProviderElement<List<User>>
    with FilteredUsersRef {
  _FilteredUsersProviderElement(super.provider);

  @override
  String get query => (origin as FilteredUsersProvider).query;
}

String _$userManagementNotifierHash() =>
    r'6a7e5d39a1dc7034bf7261618ef06301f743f07c';

/// See also [UserManagementNotifier].
@ProviderFor(UserManagementNotifier)
final userManagementNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      UserManagementNotifier,
      List<User>
    >.internal(
      UserManagementNotifier.new,
      name: r'userManagementNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userManagementNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserManagementNotifier = AutoDisposeAsyncNotifier<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
