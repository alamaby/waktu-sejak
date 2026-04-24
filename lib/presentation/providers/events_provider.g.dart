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
String _$eventsNotifierHash() => r'5b27bed66e873c504c9e5a8d91b83c7924b7bc77';

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
String _$sortTypeNotifierHash() => r'091f541a7ecc584b4099756c5e842ccd940e2f85';

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
String _$viewTypeNotifierHash() => r'51891977ed95c43958a9195dead88eec195411c7';

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
