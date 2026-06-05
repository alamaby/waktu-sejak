// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Waktu Sejak';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get create => 'Create';

  @override
  String get settings => 'Settings';

  @override
  String get cardView => 'Card View';

  @override
  String get listView => 'List View';

  @override
  String get sortByName => 'Name (A–Z)';

  @override
  String get sortByTimeClosest => 'Closest First';

  @override
  String get sortByTimeFarthest => 'Farthest First';

  @override
  String get sortLabel => 'Sort';

  @override
  String get searchEvents => 'Search events';

  @override
  String get filterAll => 'All';

  @override
  String get filterPast => 'Past';

  @override
  String get filterUpcoming => 'Upcoming';

  @override
  String get filterByEmoji => 'Filter by emoji';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noMatchingEvents =>
      'No matching events. Try clearing your filters.';

  @override
  String get eventName => 'Event Name';

  @override
  String get eventNameHint => 'e.g. My Birthday';

  @override
  String get eventNameRequired => 'Please enter an event name';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get recurrenceLabel => 'Repeat';

  @override
  String get recurrenceNone => 'None';

  @override
  String get recurrenceYearly => 'Yearly';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get searchEmoji => 'Search emoji';

  @override
  String get noEmojiResults => 'No matching emoji';

  @override
  String get emojiCategoryRecent => 'Recent';

  @override
  String get emojiCategoryPopular => 'Popular';

  @override
  String get emojiCategoryPersonal => 'Personal';

  @override
  String get emojiCategoryTravel => 'Travel';

  @override
  String get emojiCategoryVehicle => 'Vehicle';

  @override
  String get emojiCategoryWork => 'Work';

  @override
  String get emojiCategoryHealth => 'Health';

  @override
  String get emojiCategoryHome => 'Home';

  @override
  String get emojiCategoryFaith => 'Faith';

  @override
  String get colorLabel => 'Color';

  @override
  String get save => 'Save Event';

  @override
  String get update => 'Update';

  @override
  String get edit => 'Edit';

  @override
  String get editEvent => 'Edit Event';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete Event?';

  @override
  String get deleteConfirmBody => 'This action cannot be undone.';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get about => 'About';

  @override
  String get authorLabel => 'Author';

  @override
  String get authorName => 'Alam Aby Bashit';

  @override
  String get appVersionLabel => 'App Version';

  @override
  String get copyrightText => '© 2025 Alam Aby Bashit';

  @override
  String get links => 'Links';

  @override
  String get donate => 'Support Developer';

  @override
  String get noEvents => 'No events yet. Tap Create to add one.';

  @override
  String get widgetEmpty => 'No events yet';

  @override
  String get widgetTitle => 'Waktu Sejak';

  @override
  String get pastLabel => 'Past';

  @override
  String get upcomingLabel => 'Upcoming';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get couldNotOpenLink => 'Could not open link';

  @override
  String get linkedin => 'LinkedIn';

  @override
  String get github => 'GitHub';

  @override
  String get blog => 'Blog';

  @override
  String get upwork => 'Upwork';

  @override
  String get buyMeCoffee => 'Buy Me a Coffee';

  @override
  String get saweria => 'Saweria';

  @override
  String get patreon => 'Patreon';

  @override
  String get supportDeveloperSubtitle =>
      'Every support helps the developer add new features in the future.';

  @override
  String get supportDeveloperUnavailable =>
      'Google Play Billing is not available right now.';

  @override
  String get supportDeveloperProductsUnavailable =>
      'Support options are not available yet. Please check the Play Console product setup.';

  @override
  String get supportDeveloperPending => 'Waiting for Google Play…';

  @override
  String get supportDeveloperThanks =>
      'Thank you for supporting future updates.';

  @override
  String get supportDeveloperFailed =>
      'Support purchase could not be completed.';

  @override
  String get supportDeveloperCancelled => 'Support purchase was cancelled.';

  @override
  String get supporterRewardTitle => 'Support for Waktu Sejak';

  @override
  String supporterRewardBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supporter x$count',
      one: 'Supporter',
    );
    return '$_temp0';
  }

  @override
  String get supporterRewardDialogTitle => 'Thank you for the support';

  @override
  String get supporterRewardDialogBody =>
      'Your support helps Waktu Sejak keep growing with new features.';

  @override
  String get close => 'Close';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get justNow => 'Just now';

  @override
  String timeAgoY(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoYM(int years, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0, $_temp1 ago';
  }

  @override
  String timeAgoYMD(int years, int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0, $_temp1, $_temp2 ago';
  }

  @override
  String timeAgoM(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoMD(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0, $_temp1 ago';
  }

  @override
  String timeAgoD(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDHMS(int days, int hours, int minutes, int seconds) {
    return '${days}d ${hours}h ${minutes}m ${seconds}s ago';
  }

  @override
  String timeAgoHMS(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s ago';
  }

  @override
  String timeUntilY(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    return 'in $_temp0';
  }

  @override
  String timeUntilYM(int years, int months) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return 'in $_temp0, $_temp1';
  }

  @override
  String timeUntilYMD(int years, int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'in $_temp0, $_temp1, $_temp2';
  }

  @override
  String timeUntilM(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return 'in $_temp0';
  }

  @override
  String timeUntilMD(int months, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'in $_temp0, $_temp1';
  }

  @override
  String timeUntilD(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'in $_temp0';
  }

  @override
  String timeUntilDHMS(int days, int hours, int minutes, int seconds) {
    return 'in ${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String timeUntilHMS(int hours, int minutes, int seconds) {
    return 'in ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String get data => 'Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle => 'Save all events to a backup file';

  @override
  String get exportShareSubject => 'Waktu Sejak backup';

  @override
  String get importData => 'Import Data';

  @override
  String get importDataSubtitle => 'Restore events from a backup file';

  @override
  String get exportSuccess => 'Backup file ready to share';

  @override
  String get exportEmpty => 'No events to export';

  @override
  String get exportFailed => 'Failed to export data';

  @override
  String get importInvalidFormat =>
      'The selected file is not a valid Waktu Sejak backup';

  @override
  String get importFailed => 'Failed to import data';

  @override
  String importSuccessAdded(int added) {
    String _temp0 = intl.Intl.pluralLogic(
      added,
      locale: localeName,
      other: '$added events imported',
      one: '1 event imported',
      zero: 'No new events imported',
    );
    return '$_temp0';
  }

  @override
  String importSuccessSkipped(int skipped) {
    String _temp0 = intl.Intl.pluralLogic(
      skipped,
      locale: localeName,
      other: '$skipped duplicates skipped',
      one: '1 duplicate skipped',
    );
    return ' ($_temp0)';
  }

  @override
  String get sampleStartedUniversity => 'Started University';

  @override
  String get sampleNextVacation => 'Next Vacation';

  @override
  String get sampleWeddingAnniversary => 'Wedding Anniversary';

  @override
  String get sampleProjectDeadline => 'Project Deadline';
}
