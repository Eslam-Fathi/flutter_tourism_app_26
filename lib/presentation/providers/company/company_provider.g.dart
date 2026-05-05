// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myCompanyHash() => r'58adffeafaaa12e877a61b46a467f65ccc5ccf8e';

/// See also [myCompany].
@ProviderFor(myCompany)
final myCompanyProvider = AutoDisposeFutureProvider<Company?>.internal(
  myCompany,
  name: r'myCompanyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myCompanyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyCompanyRef = AutoDisposeFutureProviderRef<Company?>;
String _$companyNotifierHash() => r'e7afa3e51db31d2116c4824c1714a9127a3191fa';

/// See also [CompanyNotifier].
@ProviderFor(CompanyNotifier)
final companyNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CompanyNotifier, List<Company>>.internal(
      CompanyNotifier.new,
      name: r'companyNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$companyNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CompanyNotifier = AutoDisposeAsyncNotifier<List<Company>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
