# PROJECT_SUMMARY.md — Waktu Sejak

Technical reference for the initial mockup build. Generated after implementation.

---

## Architecture

Clean Architecture with 3 layers:

```
lib/
├── core/                   # Framework-agnostic utilities & constants
│   ├── constants/          # AppColors (Okabe-Ito palette), AppTheme (Material 3)
│   ├── utils/              # TimeCalculator — pure business logic
│   └── l10n/               # ARB files + generated delegates
├── data/
│   ├── local/              # SharedPreferences provider
│   ├── models/             # EventModel
│   ├── repositories/       # EventsRepository — JSON persistence
│   └── services/           # HomeWidgetService — Android home screen widget sync
│                           # DataPortabilityService — JSON export / import
└── presentation/
    ├── providers/          # Riverpod Notifiers + computed providers
    ├── screens/            # Dashboard, Create, Settings
    └── widgets/            # Reusable UI components
```

---

## Key Files

| File | Purpose |
|---|---|
| `lib/main.dart` | Entry point, `ProviderScope`, `MaterialApp` with locale watching, `IndexedStack` nav |
| `lib/core/constants/app_colors.dart` | Okabe-Ito 8-color palette as `const Color`, `textColorOn()` luminance helper |
| `lib/core/constants/theme_constants.dart` | Material 3 `ThemeData`, `CardTheme`, `InputDecorationTheme`, `ElevatedButtonTheme` |
| `lib/core/utils/time_calculator.dart` | `TimeDiff` struct, `calculate()` using calendar borrow-carry, `localize()` with tiered string selection |
| `lib/core/l10n/app_en.arb` | English strings with ICU plural forms |
| `lib/core/l10n/app_id.arb` | Bahasa Indonesia strings |
| `lib/data/models/event_model.dart` | `EventModel` with `id, name, targetDate, emoji, color, createdAt`, `isPast` getter, `copyWith()` |
| `lib/presentation/providers/events_provider.dart` | `EventsNotifier`, `SortTypeNotifier`, `ViewTypeNotifier`, `SelectedTab`, `sortedEvents` |
| `lib/presentation/providers/settings_provider.dart` | `LocaleNotifier`, `ThemeModeNotifier` |
| `lib/data/repositories/events_repository.dart` | JSON serialize/deserialize events to SharedPreferences; seed guard |
| `lib/data/services/home_widget_service.dart` | `HomeWidgetService.sync()` — reads events + locale from prefs, computes time strings, pushes to `home_widget` SharedPreferences, triggers Android widget update |
| `lib/data/services/data_portability_service.dart` | `DataPortabilityService.exportEvents()` writes JSON to temp dir + invokes `share_plus`; `importEvents()` picks `.json` via `file_picker`, validates schema (`app`, `version`, per-event field types), returns `List<EventModel>`. Typed exceptions: `ImportCancelled`, `ImportInvalidFormat`, `ImportIoError`, `ExportIoError` |
| `android/app/src/main/kotlin/.../WaktuSejakWidgetProvider.kt` | `HomeWidgetProvider` subclass — reads widget data, renders `RemoteViews` with 3-event list, handles tap deep-link |
| `android/app/src/main/res/layout/waktu_sejak_widget.xml` | Widget layout — header + 3 inline rows (emoji, title, subtitle) |
| `android/app/src/main/res/xml/waktu_sejak_widget_info.xml` | AppWidget metadata — size, preview, description |
| `lib/presentation/screens/dashboard_screen.dart` | `ConsumerStatefulWidget`, `Timer.periodic(1s)`, `GridView`/`ListView` toggle |
| `lib/presentation/screens/event_form_screen.dart` | Form with live preview card, `showDatePicker`+`showTimePicker`, random init; doubles as Create & Edit |
| `lib/presentation/screens/settings_screen.dart` | `SegmentedButton<Locale>` (language), `SegmentedButton<ThemeMode>` (System/Light/Dark), About, Data (Export/Import via `DataPortabilityService`), Links, Donate |
| `lib/presentation/widgets/event_card.dart` | Color card with luminance-based text, long-press delete dialog |
| `lib/presentation/widgets/event_list_tile.dart` | `Dismissible` swipe-to-delete, status chip |
| `lib/presentation/widgets/color_picker_widget.dart` | 7 Okabe-Ito swatches, checkmark on selected |
| `lib/presentation/widgets/emoji_picker_dialog.dart` | `showDialog` with 32 curated Unicode emoji |

---

## State Management

All state is managed with **Riverpod 2.x** (`@riverpod` annotations, code-generated via `riverpod_generator`).

### Providers

| Provider | Type | State |
|---|---|---|
| `eventsNotifierProvider` | `AutoDisposeNotifierProvider<EventsNotifier, List<EventModel>>` | Master event list |
| `sortTypeNotifierProvider` | `AutoDisposeNotifierProvider<SortTypeNotifier, SortType>` | Enum: `byName / byTimeClosest / byTimeFarthest` |
| `viewTypeNotifierProvider` | `AutoDisposeNotifierProvider<ViewTypeNotifier, ViewType>` | Enum: `card / list` |
| `selectedTabProvider` | `AutoDisposeNotifierProvider<SelectedTab, int>` | Bottom nav index 0–2 |
| `sortedEventsProvider` | `AutoDisposeProvider<List<EventModel>>` | Computed: sorted events |
| `localeNotifierProvider` | `AutoDisposeNotifierProvider<LocaleNotifier, Locale>` | Active locale (`en` / `id`); persisted |
| `themeModeNotifierProvider` | `AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>` | Active theme (`system` / `light` / `dark`); persisted |

### Tab Navigation Pattern

`MainScaffold` watches `selectedTabProvider`. Child screens call:
```dart
ref.read(selectedTabProvider.notifier).select(0);
```
This avoids passing callbacks through `IndexedStack` children.

---

## Time Calculation Algorithm

Located in `lib/core/utils/time_calculator.dart`.

Uses **calendar-aware borrow-carry subtraction**, not naive `inDays / 30`:

```dart
int years  = to.year  - from.year;
int months = to.month - from.month;
int days   = to.day   - from.day;
int hours  = to.hour  - from.hour;
int mins   = to.minute - from.minute;
int secs   = to.second - from.second;

if (secs   < 0) { mins   -= 1; secs   += 60; }
if (mins   < 0) { hours  -= 1; mins   += 60; }
if (hours  < 0) { days   -= 1; hours  += 24; }
if (days   < 0) { months -= 1; days   += DateUtils.getDaysInMonth(prevYear, prevMonth); }
if (months < 0) { years  -= 1; months += 12; }
```

`localize()` selects the appropriate ARB key based on which components are non-zero:
- `years > 0` → YMD / YM / Y tier
- `months > 0` → MD / M tier
- else → DHMS / HMS tier
- all zero → `justNow`

---

## Localization

- Framework: `flutter_localizations` + `intl`
- Config: `l10n.yaml` at project root
- Output: `lib/core/l10n/generated/app_localizations.dart` (auto-generated)
- Supported: `en` (English), `id` (Bahasa Indonesia)
- Uses ICU plural syntax in `.arb` for correct singular/plural (e.g. `"1 year"` vs `"2 years"`)
- `nullable-getter: false` in `l10n.yaml` — `AppLocalizations.of(context)` returns non-null everywhere

---

## Color System

**Okabe-Ito palette** — designed for color-blind accessibility:

| Name | Hex | Index |
|---|---|---|
| Orange | `#E69F00` | 0 |
| Sky Blue | `#56B4E9` | 1 |
| Bluish Green | `#009E73` | 2 |
| Yellow | `#F0E442` | 3 |
| Blue | `#0072B2` | 4 |
| Vermillion | `#D55E00` | 5 |
| Reddish Purple | `#CC79A7` | 6 |
| Black | `#000000` | 7 (excluded from random pick) |

Text color on cards is auto-selected by luminance:
```dart
static Color textColorOn(Color background) {
  return background.computeLuminance() > 0.4 ? Color(0xFF1A1A1A) : Colors.white;
}
```

---

## Real-Time Timer

Dashboard uses `ConsumerStatefulWidget` with `Timer.periodic`:
```dart
_timer = Timer.periodic(const Duration(seconds: 1), (_) {
  if (mounted) setState(() {});
});
```
`setState` is used (not `ref.invalidate`) to avoid Riverpod graph re-evaluation every second — only the widget subtree rebuilds.

---

## Dependency Decisions

| Decision | Reason |
|---|---|
| No `freezed` | Model is simple; manual `copyWith` avoids extra codegen step |
| No `go_router` | 3 tabs + `IndexedStack` + one int provider is sufficient |
| `url_launcher` | Used for social/support links in Settings screen |
| `home_widget` | Bridge between Flutter SharedPreferences and Android AppWidget `RemoteViews`; no `workmanager` (widget syncs on app start + event mutation + locale change) |
| `share_plus` + `path_provider` | Export flow writes JSON to temp dir via `path_provider` then hands off to OS share sheet via `share_plus` — avoids needing storage permissions |
| `file_picker` | Import flow uses the system file picker (`FileType.custom`, `allowedExtensions: ['json']`, `withData: true`) — works on Android and web without extra permissions |
| `SharedPreferences` for persistence | Simple key-value store sufficient for events (JSON) + settings (strings); avoids Hive/Isar codegen overhead |
| `Notifier` not `StateNotifier` | `StateNotifier` is soft-deprecated in Riverpod 2.x |

---

## Build Notes

### Dependency fix applied
`intl` was pinned to `^0.20.2` (up from `^0.19.0`) because `flutter_localizations` SDK locks it.

### Deprecations resolved
- `withOpacity()` → `.withValues(alpha: x)` (Flutter 3.x deprecation)
- `Color.value` → `.toARGB32()` for color comparison

### Code generation commands
```bash
flutter gen-l10n                                          # l10n delegates
dart run build_runner build --delete-conflicting-outputs  # Riverpod .g.dart files
```

Final `flutter analyze`: **0 issues**.

---

## Dummy Events (pre-loaded)

| Name | Target Date | Emoji | Color |
|---|---|---|---|
| Started University | 2 Sep 2019 | 🎓 | Sky Blue |
| Next Vacation | now + 45 days | ✈️ | Bluish Green |
| Wedding Anniversary | 15 Jun 2022 | 💍 | Vermillion |
| Project Deadline | now + 7 days | 📅 | Orange |

---

## Data Portability

Located in `lib/data/services/data_portability_service.dart` + `EventsNotifier.importAppend()` in `lib/presentation/providers/events_provider.dart`.

### Export
- Builds payload `{ app: 'waktu_sejak', version: 1, exportedAt: <ISO8601>, events: [...] }`
- Filename: `waktu_sejak_backup_yyyyMMddHHmmss.json`
- Writes to `getTemporaryDirectory()` then invokes `Share.shareXFiles` with `mimeType: 'application/json'`
- No storage permission needed (temp dir + share sheet)

### Import
- `FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'], withData: true)`
- Validates: top-level is `Map`; `app == 'waktu_sejak'` (if present); `version <= 1`; `events` is `List`; each entry has required keys with correct types and parseable dates
- Cancellation, invalid format, and I/O errors raise distinct typed exceptions so the UI can render the right SnackBar

### Merge strategy
- `EventsNotifier.importAppend(List<EventModel>)` — append-only, dedupe by `id`, single `_persist()` call, returns count actually added so the UI can report `added` and `skipped` counts via pluralized ARB keys (`importSuccessAdded`, `importSuccessSkipped`)

---

## What's NOT Implemented (Next Phase)

- Push notifications / reminders
- iOS home screen widget (WidgetKit — skipped in current iteration)
- Replace-all import strategy (only append-merge supported)
