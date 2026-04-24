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
│   └── models/             # EventModel (in-memory only, no persistence)
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
| `lib/presentation/providers/settings_provider.dart` | `LocaleNotifier` |
| `lib/presentation/screens/dashboard_screen.dart` | `ConsumerStatefulWidget`, `Timer.periodic(1s)`, `GridView`/`ListView` toggle |
| `lib/presentation/screens/create_screen.dart` | Form with live preview card, `showDatePicker`+`showTimePicker`, random init |
| `lib/presentation/screens/settings_screen.dart` | `SegmentedButton<Locale>`, About/Links/Donate sections |
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
| `localeNotifierProvider` | `AutoDisposeNotifierProvider<LocaleNotifier, Locale>` | Active locale (`en` / `id`) |

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
| No `url_launcher` | Links are placeholder phase; `SnackBar("Coming soon")` used |
| No `hive`/`isar` | In-memory only per project spec for mockup phase |
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

## What's NOT Implemented (Next Phase)

- Local persistence (Isar or Hive)
- Real URL launching (`url_launcher`)
- Dark mode
- Push notifications / reminders
- Widget (home screen widget)
- Event editing (currently add/delete only)
