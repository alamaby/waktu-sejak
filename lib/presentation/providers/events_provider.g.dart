// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sortedEventsHash() => r'c80a955962c636efae4c0a66135a66f6367449c7';

/// See also [sortedEvents].
@ProviderFor(sortedEvents)
final sortedEventsProvider = AutoDisposeProvider<List<EventModel>>.internal(
  sortedEvents,
  name: r'sortedEventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sortedEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SortedEventsRef = AutoDisposeProviderRef<List<EventModel>>;
String _$eventsNotifierHash() => r'4a8f3ef97dcc2921d7da5e79feb626557cf8cf7f';

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
