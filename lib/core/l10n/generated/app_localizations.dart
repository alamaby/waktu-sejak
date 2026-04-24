import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Waktu Sejak'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @cardView.
  ///
  /// In en, this message translates to:
  /// **'Card View'**
  String get cardView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get sortByName;

  /// No description provided for @sortByTimeClosest.
  ///
  /// In en, this message translates to:
  /// **'Closest First'**
  String get sortByTimeClosest;

  /// No description provided for @sortByTimeFarthest.
  ///
  /// In en, this message translates to:
  /// **'Farthest First'**
  String get sortByTimeFarthest;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get eventName;

  /// No description provided for @eventNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Birthday'**
  String get eventNameHint;

  /// No description provided for @eventNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an event name'**
  String get eventNameRequired;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @emojiLabel.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get emojiLabel;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save Event'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Event?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @authorLabel.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get authorLabel;

  /// No description provided for @authorName.
  ///
  /// In en, this message translates to:
  /// **'Alam Aby Bashit'**
  String get authorName;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// No description provided for @donate.
  ///
  /// In en, this message translates to:
  /// **'Support the App'**
  String get donate;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet. Tap Create to add one.'**
  String get noEvents;

  /// No description provided for @pastLabel.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get pastLabel;

  /// No description provided for @upcomingLabel.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingLabel;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;

  /// No description provided for @linkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedin;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @upwork.
  ///
  /// In en, this message translates to:
  /// **'Upwork'**
  String get upwork;

  /// No description provided for @buyMeCoffee.
  ///
  /// In en, this message translates to:
  /// **'Buy Me a Coffee'**
  String get buyMeCoffee;

  /// No description provided for @saweria.
  ///
  /// In en, this message translates to:
  /// **'Saweria'**
  String get saweria;

  /// No description provided for @patreon.
  ///
  /// In en, this message translates to:
  /// **'Patreon'**
  String get patreon;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @timeAgoY.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year ago} other{{years} years ago}}'**
  String timeAgoY(int years);

  /// No description provided for @timeAgoYM.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year} other{{years} years}}, {months, plural, =1{1 month} other{{months} months}} ago'**
  String timeAgoYM(int years, int months);

  /// No description provided for @timeAgoYMD.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year} other{{years} years}}, {months, plural, =1{1 month} other{{months} months}}, {days, plural, =1{1 day} other{{days} days}} ago'**
  String timeAgoYMD(int years, int months, int days);

  /// No description provided for @timeAgoM.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{1 month ago} other{{months} months ago}}'**
  String timeAgoM(int months);

  /// No description provided for @timeAgoMD.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{1 month} other{{months} months}}, {days, plural, =1{1 day} other{{days} days}} ago'**
  String timeAgoMD(int months, int days);

  /// No description provided for @timeAgoD.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day ago} other{{days} days ago}}'**
  String timeAgoD(int days);

  /// No description provided for @timeAgoDHMS.
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h {minutes}m {seconds}s ago'**
  String timeAgoDHMS(int days, int hours, int minutes, int seconds);

  /// No description provided for @timeAgoHMS.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m {seconds}s ago'**
  String timeAgoHMS(int hours, int minutes, int seconds);

  /// No description provided for @timeUntilY.
  ///
  /// In en, this message translates to:
  /// **'in {years, plural, =1{1 year} other{{years} years}}'**
  String timeUntilY(int years);

  /// No description provided for @timeUntilYM.
  ///
  /// In en, this message translates to:
  /// **'in {years, plural, =1{1 year} other{{years} years}}, {months, plural, =1{1 month} other{{months} months}}'**
  String timeUntilYM(int years, int months);

  /// No description provided for @timeUntilYMD.
  ///
  /// In en, this message translates to:
  /// **'in {years, plural, =1{1 year} other{{years} years}}, {months, plural, =1{1 month} other{{months} months}}, {days, plural, =1{1 day} other{{days} days}}'**
  String timeUntilYMD(int years, int months, int days);

  /// No description provided for @timeUntilM.
  ///
  /// In en, this message translates to:
  /// **'in {months, plural, =1{1 month} other{{months} months}}'**
  String timeUntilM(int months);

  /// No description provided for @timeUntilMD.
  ///
  /// In en, this message translates to:
  /// **'in {months, plural, =1{1 month} other{{months} months}}, {days, plural, =1{1 day} other{{days} days}}'**
  String timeUntilMD(int months, int days);

  /// No description provided for @timeUntilD.
  ///
  /// In en, this message translates to:
  /// **'in {days, plural, =1{1 day} other{{days} days}}'**
  String timeUntilD(int days);

  /// No description provided for @timeUntilDHMS.
  ///
  /// In en, this message translates to:
  /// **'in {days}d {hours}h {minutes}m {seconds}s'**
  String timeUntilDHMS(int days, int hours, int minutes, int seconds);

  /// No description provided for @timeUntilHMS.
  ///
  /// In en, this message translates to:
  /// **'in {hours}h {minutes}m {seconds}s'**
  String timeUntilHMS(int hours, int minutes, int seconds);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
