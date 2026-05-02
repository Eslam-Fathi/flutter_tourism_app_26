// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$articleNotifierHash() => r'86686c0a3de0d3069d9c9ff60348f212e85c7756';

/// See also [ArticleNotifier].
@ProviderFor(ArticleNotifier)
final articleNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ArticleNotifier,
      List<HistoricalArticle>
    >.internal(
      ArticleNotifier.new,
      name: r'articleNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$articleNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ArticleNotifier = AutoDisposeAsyncNotifier<List<HistoricalArticle>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
