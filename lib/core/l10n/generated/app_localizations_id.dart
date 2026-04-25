// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Waktu Sejak';

  @override
  String get dashboard => 'Dasbor';

  @override
  String get create => 'Buat';

  @override
  String get settings => 'Pengaturan';

  @override
  String get cardView => 'Tampilan Kartu';

  @override
  String get listView => 'Tampilan Daftar';

  @override
  String get sortByName => 'Nama (A–Z)';

  @override
  String get sortByTimeClosest => 'Terdekat Dulu';

  @override
  String get sortByTimeFarthest => 'Terjauh Dulu';

  @override
  String get sortLabel => 'Urutkan';

  @override
  String get eventName => 'Nama Acara';

  @override
  String get eventNameHint => 'cth. Ulang Tahun Saya';

  @override
  String get eventNameRequired => 'Harap masukkan nama acara';

  @override
  String get dateAndTime => 'Tanggal & Waktu';

  @override
  String get emojiLabel => 'Emoji';

  @override
  String get colorLabel => 'Warna';

  @override
  String get save => 'Simpan Acara';

  @override
  String get update => 'Perbarui';

  @override
  String get edit => 'Ubah';

  @override
  String get editEvent => 'Ubah Acara';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteConfirmTitle => 'Hapus Acara?';

  @override
  String get deleteConfirmBody => 'Tindakan ini tidak dapat dibatalkan.';

  @override
  String get language => 'Bahasa';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get about => 'Tentang';

  @override
  String get authorLabel => 'Pembuat';

  @override
  String get authorName => 'Alam Aby Bashit';

  @override
  String get links => 'Tautan';

  @override
  String get donate => 'Dukung Aplikasi';

  @override
  String get noEvents => 'Belum ada acara. Ketuk Buat untuk menambahkan.';

  @override
  String get pastLabel => 'Lalu';

  @override
  String get upcomingLabel => 'Mendatang';

  @override
  String get comingSoon => 'Segera hadir!';

  @override
  String get couldNotOpenLink => 'Tidak dapat membuka tautan';

  @override
  String get linkedin => 'LinkedIn';

  @override
  String get github => 'GitHub';

  @override
  String get blog => 'Blog';

  @override
  String get upwork => 'Upwork';

  @override
  String get buyMeCoffee => 'Traktir Kopi';

  @override
  String get saweria => 'Saweria';

  @override
  String get patreon => 'Patreon';

  @override
  String get justNow => 'Baru saja';

  @override
  String timeAgoY(int years) {
    return '$years tahun yang lalu';
  }

  @override
  String timeAgoYM(int years, int months) {
    return '$years tahun, $months bulan yang lalu';
  }

  @override
  String timeAgoYMD(int years, int months, int days) {
    return '$years tahun, $months bulan, $days hari yang lalu';
  }

  @override
  String timeAgoM(int months) {
    return '$months bulan yang lalu';
  }

  @override
  String timeAgoMD(int months, int days) {
    return '$months bulan, $days hari yang lalu';
  }

  @override
  String timeAgoD(int days) {
    return '$days hari yang lalu';
  }

  @override
  String timeAgoDHMS(int days, int hours, int minutes, int seconds) {
    return '$days hari $hours jam $minutes menit $seconds detik yang lalu';
  }

  @override
  String timeAgoHMS(int hours, int minutes, int seconds) {
    return '$hours jam $minutes menit $seconds detik yang lalu';
  }

  @override
  String timeUntilY(int years) {
    return 'dalam $years tahun';
  }

  @override
  String timeUntilYM(int years, int months) {
    return 'dalam $years tahun, $months bulan';
  }

  @override
  String timeUntilYMD(int years, int months, int days) {
    return 'dalam $years tahun, $months bulan, $days hari';
  }

  @override
  String timeUntilM(int months) {
    return 'dalam $months bulan';
  }

  @override
  String timeUntilMD(int months, int days) {
    return 'dalam $months bulan, $days hari';
  }

  @override
  String timeUntilD(int days) {
    return 'dalam $days hari';
  }

  @override
  String timeUntilDHMS(int days, int hours, int minutes, int seconds) {
    return 'dalam $days hari $hours jam $minutes menit $seconds detik';
  }

  @override
  String timeUntilHMS(int hours, int minutes, int seconds) {
    return 'dalam $hours jam $minutes menit $seconds detik';
  }
}
