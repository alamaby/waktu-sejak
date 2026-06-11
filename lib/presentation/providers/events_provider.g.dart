// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableEventEmojisHash() =>
    r'8dac2066936d44242aa6b9146db25e346407e8a3';

/// See also [availableEventEmojis].
@ProviderFor(availableEventEmojis)
final availableEventEmojisProvider = AutoDisposeProvider<List<String>>.internal(
  availableEventEmojis,
  name: r'availableEventEmojisProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableEventEmojisHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableEventEmojisRef = AutoDisposeProviderRef<List<String>>;
String _$hasActiveEventFiltersHash() =>
    r'806e29312b0b5e29021c260a846744350dbd445a';

/// See also [hasActiveEventFilters].
@ProviderFor(hasActiveEventFilters)
final hasActiveEventFiltersProvider = AutoDisposeProvider<bool>.internal(
  hasActiveEventFilters,
  name: r'hasActiveEventFiltersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasActiveEventFiltersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasActiveEventFiltersRef = AutoDisposeProviderRef<bool>;
String _$visibleEventsHash() => r'd889302da35cb415573cf48a834814facf367cc4';

/// See also [visibleEvents].
@ProviderFor(visibleEvents)
final visibleEventsProvider = AutoDisposeProvider<List<EventModel>>.internal(
  visibleEvents,
  name: r'visibleEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$visibleEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VisibleEventsRef = AutoDisposeProviderRef<List<EventModel>>;
String _$eventsNotifierHash() => r'ef93db307a88a0a70dead94c748d343e8cf0a5f1';

/// See also [EventsNotifier].
@ProviderFor(EventsNotifier)
final eventsNotifierProvider =
    AutoDisposeNotifierProvider<EventsNotifier, List<EventModel>>.internal(
  EventsNotifier.new,
  name: r'eventsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventsNotifier = AutoDisposeNotifier<List<EventModel>>;
String _$sortTypeNotifierHash() => r'e3b9e3aabe3b808605dba8a2b0f370ee1ae220b5';

/// See also [SortTypeNotifier].
@ProviderFor(SortTypeNotifier)
final sortTypeNotifierProvider =
    AutoDisposeNotifierProvider<SortTypeNotifier, SortType>.internal(
  SortTypeNotifier.new,
  name: r'sortTypeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SortTypeNotifier = AutoDisposeNotifier<SortType>;
String _$viewTypeNotifierHash() => r'fd9b5ad46a467e9bf9a19550c8e40b664a78e80d';

/// See also [ViewTypeNotifier].
@ProviderFor(ViewTypeNotifier)
final viewTypeNotifierProvider =
    AutoDisposeNotifierProvider<ViewTypeNotifier, ViewType>.internal(
  ViewTypeNotifier.new,
  name: r'viewTypeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$viewTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ViewTypeNotifier = AutoDisposeNotifier<ViewType>;
String _$eventSearchQueryHash() => r'e82468eb75a84dbbcf102188419328fe4deaf5ef';

/// See also [EventSearchQuery].
@ProviderFor(EventSearchQuery)
final eventSearchQueryProvider =
    AutoDisposeNotifierProvider<EventSearchQuery, String>.internal(
  EventSearchQuery.new,
  name: r'eventSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventSearchQuery = AutoDisposeNotifier<String>;
String _$eventStatusFilterNotifierHash() =>
    r'8f62ceacf195933f3bb1313f865d3f87b3c8cc3c';

/// See also [EventStatusFilterNotifier].
@ProviderFor(EventStatusFilterNotifier)
final eventStatusFilterNotifierProvider = AutoDisposeNotifierProvider<
    EventStatusFilterNotifier, EventStatusFilter>.internal(
  EventStatusFilterNotifier.new,
  name: r'eventStatusFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventStatusFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventStatusFilterNotifier = AutoDisposeNotifier<EventStatusFilter>;
String _$eventEmojiFilterHash() => r'6be3f63663b8c45441b5e77440edbe60d97e277a';

/// See also [EventEmojiFilter].
@ProviderFor(EventEmojiFilter)
final eventEmojiFilterProvider =
    AutoDisposeNotifierProvider<EventEmojiFilter, String?>.internal(
  EventEmojiFilter.new,
  name: r'eventEmojiFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eventEmojiFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EventEmojiFilter = AutoDisposeNotifier<String?>;
String _$selectedTabHash() => r'55810268ff34c5e8326c396448452ea615c7da52';

/// See also [SelectedTab].
@ProviderFor(SelectedTab)
final selectedTabProvider =
    AutoDisposeNotifierProvider<SelectedTab, int>.internal(
  SelectedTab.new,
  name: r'selectedTabProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedTabHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTab = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
