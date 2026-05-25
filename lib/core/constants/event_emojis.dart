enum EventEmojiCategory {
  popular,
  personal,
  travel,
  vehicle,
  work,
  health,
  home,
  faith,
}

class EventEmojiOption {
  final String emoji;
  final EventEmojiCategory category;
  final List<String> keywords;

  const EventEmojiOption({
    required this.emoji,
    required this.category,
    required this.keywords,
  });

  bool matches(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return emoji == normalized ||
        keywords.any((keyword) => keyword.toLowerCase().contains(normalized));
  }
}

const eventEmojiOptions = [
  EventEmojiOption(
    emoji: '🎂',
    category: EventEmojiCategory.personal,
    keywords: ['birthday', 'ulang tahun', 'cake', 'kue'],
  ),
  EventEmojiOption(
    emoji: '🎓',
    category: EventEmojiCategory.personal,
    keywords: ['graduation', 'school', 'wisuda', 'sekolah', 'kuliah'],
  ),
  EventEmojiOption(
    emoji: '💍',
    category: EventEmojiCategory.personal,
    keywords: ['wedding', 'anniversary', 'nikah', 'menikah', 'tunangan'],
  ),
  EventEmojiOption(
    emoji: '✈️',
    category: EventEmojiCategory.travel,
    keywords: ['flight', 'travel', 'vacation', 'pesawat', 'liburan'],
  ),
  EventEmojiOption(
    emoji: '🏠',
    category: EventEmojiCategory.home,
    keywords: ['home', 'house', 'rumah', 'pindahan'],
  ),
  EventEmojiOption(
    emoji: '🚀',
    category: EventEmojiCategory.work,
    keywords: ['launch', 'startup', 'rilis', 'peluncuran'],
  ),
  EventEmojiOption(
    emoji: '🎉',
    category: EventEmojiCategory.popular,
    keywords: ['party', 'celebration', 'pesta', 'perayaan'],
  ),
  EventEmojiOption(
    emoji: '🏆',
    category: EventEmojiCategory.popular,
    keywords: ['trophy', 'award', 'goal', 'juara', 'menang'],
  ),
  EventEmojiOption(
    emoji: '💪',
    category: EventEmojiCategory.health,
    keywords: ['fitness', 'gym', 'strong', 'olahraga', 'latihan'],
  ),
  EventEmojiOption(
    emoji: '❤️',
    category: EventEmojiCategory.personal,
    keywords: ['love', 'heart', 'cinta', 'sayang'],
  ),
  EventEmojiOption(
    emoji: '🌟',
    category: EventEmojiCategory.popular,
    keywords: ['star', 'favorite', 'bintang', 'spesial'],
  ),
  EventEmojiOption(
    emoji: '🎵',
    category: EventEmojiCategory.personal,
    keywords: ['music', 'song', 'musik', 'lagu'],
  ),
  EventEmojiOption(
    emoji: '📅',
    category: EventEmojiCategory.popular,
    keywords: ['calendar', 'event', 'date', 'kalender', 'jadwal'],
  ),
  EventEmojiOption(
    emoji: '💼',
    category: EventEmojiCategory.work,
    keywords: ['work', 'job', 'office', 'kerja', 'kantor'],
  ),
  EventEmojiOption(
    emoji: '🐶',
    category: EventEmojiCategory.personal,
    keywords: ['pet', 'dog', 'hewan', 'anjing'],
  ),
  EventEmojiOption(
    emoji: '🌏',
    category: EventEmojiCategory.travel,
    keywords: ['world', 'earth', 'travel', 'dunia', 'bumi'],
  ),
  EventEmojiOption(
    emoji: '🔥',
    category: EventEmojiCategory.popular,
    keywords: ['fire', 'hot', 'streak', 'api', 'semangat'],
  ),
  EventEmojiOption(
    emoji: '🏋️',
    category: EventEmojiCategory.health,
    keywords: ['gym', 'workout', 'angkat beban', 'fitness'],
  ),
  EventEmojiOption(
    emoji: '🎮',
    category: EventEmojiCategory.personal,
    keywords: ['game', 'gaming', 'main game'],
  ),
  EventEmojiOption(
    emoji: '📚',
    category: EventEmojiCategory.work,
    keywords: ['book', 'study', 'read', 'buku', 'belajar'],
  ),
  EventEmojiOption(
    emoji: '☕',
    category: EventEmojiCategory.popular,
    keywords: ['coffee', 'cafe', 'kopi'],
  ),
  EventEmojiOption(
    emoji: '🌈',
    category: EventEmojiCategory.popular,
    keywords: ['rainbow', 'color', 'pelangi', 'warna'],
  ),
  EventEmojiOption(
    emoji: '🎸',
    category: EventEmojiCategory.personal,
    keywords: ['guitar', 'music', 'gitar', 'musik'],
  ),
  EventEmojiOption(
    emoji: '🍕',
    category: EventEmojiCategory.personal,
    keywords: ['pizza', 'food', 'makan'],
  ),
  EventEmojiOption(
    emoji: '🌺',
    category: EventEmojiCategory.personal,
    keywords: ['flower', 'garden', 'bunga', 'taman'],
  ),
  EventEmojiOption(
    emoji: '⚽',
    category: EventEmojiCategory.health,
    keywords: ['football', 'soccer', 'bola', 'sepak bola'],
  ),
  EventEmojiOption(
    emoji: '🎯',
    category: EventEmojiCategory.work,
    keywords: ['target', 'goal', 'tujuan'],
  ),
  EventEmojiOption(
    emoji: '🧘',
    category: EventEmojiCategory.health,
    keywords: ['meditation', 'yoga', 'meditasi'],
  ),
  EventEmojiOption(
    emoji: '🏖️',
    category: EventEmojiCategory.travel,
    keywords: ['beach', 'holiday', 'pantai', 'liburan'],
  ),
  EventEmojiOption(
    emoji: '🦋',
    category: EventEmojiCategory.personal,
    keywords: ['butterfly', 'kupu-kupu', 'change'],
  ),
  EventEmojiOption(
    emoji: '🎪',
    category: EventEmojiCategory.personal,
    keywords: ['circus', 'show', 'festival'],
  ),
  EventEmojiOption(
    emoji: '🧩',
    category: EventEmojiCategory.personal,
    keywords: ['puzzle', 'hobby', 'teka-teki'],
  ),
  EventEmojiOption(
    emoji: '🚗',
    category: EventEmojiCategory.vehicle,
    keywords: ['car', 'auto', 'mobil', 'kendaraan'],
  ),
  EventEmojiOption(
    emoji: '🚙',
    category: EventEmojiCategory.vehicle,
    keywords: ['suv', 'car', 'mobil', 'kendaraan'],
  ),
  EventEmojiOption(
    emoji: '🚘',
    category: EventEmojiCategory.vehicle,
    keywords: ['car', 'automotive', 'mobil', 'otomotif'],
  ),
  EventEmojiOption(
    emoji: '🛵',
    category: EventEmojiCategory.vehicle,
    keywords: ['motorbike', 'scooter', 'motor', 'skuter'],
  ),
  EventEmojiOption(
    emoji: '🚲',
    category: EventEmojiCategory.vehicle,
    keywords: ['bike', 'bicycle', 'sepeda'],
  ),
  EventEmojiOption(
    emoji: '🚌',
    category: EventEmojiCategory.vehicle,
    keywords: ['bus', 'transport', 'bis', 'transportasi'],
  ),
  EventEmojiOption(
    emoji: '🚆',
    category: EventEmojiCategory.travel,
    keywords: ['train', 'rail', 'kereta'],
  ),
  EventEmojiOption(
    emoji: '⛽',
    category: EventEmojiCategory.vehicle,
    keywords: ['fuel', 'gas', 'bensin', 'bbm'],
  ),
  EventEmojiOption(
    emoji: '🔧',
    category: EventEmojiCategory.vehicle,
    keywords: ['service', 'repair', 'tool', 'servis', 'bengkel', 'perbaikan'],
  ),
  EventEmojiOption(
    emoji: '🛠️',
    category: EventEmojiCategory.vehicle,
    keywords: ['maintenance', 'repair', 'service', 'servis', 'bengkel'],
  ),
  EventEmojiOption(
    emoji: '🧰',
    category: EventEmojiCategory.vehicle,
    keywords: ['toolbox', 'tools', 'service', 'servis', 'alat'],
  ),
  EventEmojiOption(
    emoji: '🛞',
    category: EventEmojiCategory.vehicle,
    keywords: ['tire', 'wheel', 'ban', 'roda', 'mobil'],
  ),
  EventEmojiOption(
    emoji: '🔋',
    category: EventEmojiCategory.vehicle,
    keywords: ['battery', 'charge', 'aki', 'baterai'],
  ),
  EventEmojiOption(
    emoji: '🧼',
    category: EventEmojiCategory.vehicle,
    keywords: ['wash', 'clean', 'car wash', 'cuci', 'bersih'],
  ),
  EventEmojiOption(
    emoji: '🧾',
    category: EventEmojiCategory.work,
    keywords: ['receipt', 'bill', 'invoice', 'nota', 'tagihan'],
  ),
  EventEmojiOption(
    emoji: '🏁',
    category: EventEmojiCategory.vehicle,
    keywords: ['race', 'finish', 'racing', 'balap', 'selesai'],
  ),
  EventEmojiOption(
    emoji: '👶',
    category: EventEmojiCategory.personal,
    keywords: ['baby', 'birth', 'bayi', 'lahir'],
  ),
  EventEmojiOption(
    emoji: '👨‍👩‍👧‍👦',
    category: EventEmojiCategory.personal,
    keywords: ['family', 'keluarga'],
  ),
  EventEmojiOption(
    emoji: '🎁',
    category: EventEmojiCategory.personal,
    keywords: ['gift', 'present', 'hadiah', 'kado'],
  ),
  EventEmojiOption(
    emoji: '🎈',
    category: EventEmojiCategory.personal,
    keywords: ['balloon', 'party', 'balon', 'pesta'],
  ),
  EventEmojiOption(
    emoji: '🥳',
    category: EventEmojiCategory.popular,
    keywords: ['party', 'celebrate', 'pesta', 'rayakan'],
  ),
  EventEmojiOption(
    emoji: '📸',
    category: EventEmojiCategory.personal,
    keywords: ['photo', 'camera', 'foto', 'kamera'],
  ),
  EventEmojiOption(
    emoji: '🎬',
    category: EventEmojiCategory.personal,
    keywords: ['movie', 'film', 'cinema', 'bioskop'],
  ),
  EventEmojiOption(
    emoji: '🎤',
    category: EventEmojiCategory.personal,
    keywords: ['karaoke', 'sing', 'nyanyi'],
  ),
  EventEmojiOption(
    emoji: '💻',
    category: EventEmojiCategory.work,
    keywords: ['laptop', 'computer', 'code', 'komputer', 'kode'],
  ),
  EventEmojiOption(
    emoji: '📱',
    category: EventEmojiCategory.work,
    keywords: ['phone', 'mobile', 'hp', 'ponsel'],
  ),
  EventEmojiOption(
    emoji: '📝',
    category: EventEmojiCategory.work,
    keywords: ['note', 'task', 'writing', 'catatan', 'tugas'],
  ),
  EventEmojiOption(
    emoji: '📌',
    category: EventEmojiCategory.work,
    keywords: ['pin', 'important', 'penting'],
  ),
  EventEmojiOption(
    emoji: '📈',
    category: EventEmojiCategory.work,
    keywords: ['chart', 'growth', 'target', 'grafik', 'naik'],
  ),
  EventEmojiOption(
    emoji: '💰',
    category: EventEmojiCategory.work,
    keywords: ['money', 'finance', 'uang', 'keuangan'],
  ),
  EventEmojiOption(
    emoji: '🏦',
    category: EventEmojiCategory.work,
    keywords: ['bank', 'finance', 'tabungan', 'keuangan'],
  ),
  EventEmojiOption(
    emoji: '🛒',
    category: EventEmojiCategory.home,
    keywords: ['shopping', 'grocery', 'belanja'],
  ),
  EventEmojiOption(
    emoji: '🏥',
    category: EventEmojiCategory.health,
    keywords: ['hospital', 'clinic', 'rumah sakit', 'klinik'],
  ),
  EventEmojiOption(
    emoji: '💊',
    category: EventEmojiCategory.health,
    keywords: ['medicine', 'pill', 'obat'],
  ),
  EventEmojiOption(
    emoji: '🩺',
    category: EventEmojiCategory.health,
    keywords: ['doctor', 'checkup', 'dokter', 'kontrol'],
  ),
  EventEmojiOption(
    emoji: '🦷',
    category: EventEmojiCategory.health,
    keywords: ['dentist', 'tooth', 'gigi', 'dokter gigi'],
  ),
  EventEmojiOption(
    emoji: '💉',
    category: EventEmojiCategory.health,
    keywords: ['vaccine', 'shot', 'vaksin', 'suntik'],
  ),
  EventEmojiOption(
    emoji: '🧪',
    category: EventEmojiCategory.health,
    keywords: ['lab', 'test', 'tes', 'laboratorium'],
  ),
  EventEmojiOption(
    emoji: '🍽️',
    category: EventEmojiCategory.personal,
    keywords: ['dinner', 'restaurant', 'makan', 'restoran'],
  ),
  EventEmojiOption(
    emoji: '🍳',
    category: EventEmojiCategory.home,
    keywords: ['cook', 'breakfast', 'masak', 'sarapan'],
  ),
  EventEmojiOption(
    emoji: '🌙',
    category: EventEmojiCategory.faith,
    keywords: ['moon', 'night', 'ramadan', 'bulan', 'malam'],
  ),
  EventEmojiOption(
    emoji: '☀️',
    category: EventEmojiCategory.popular,
    keywords: ['sun', 'morning', 'summer', 'matahari', 'pagi'],
  ),
  EventEmojiOption(
    emoji: '⏰',
    category: EventEmojiCategory.popular,
    keywords: ['alarm', 'reminder', 'time', 'pengingat', 'waktu'],
  ),
  EventEmojiOption(
    emoji: '✅',
    category: EventEmojiCategory.work,
    keywords: ['done', 'check', 'complete', 'selesai'],
  ),
  EventEmojiOption(
    emoji: '🙏',
    category: EventEmojiCategory.faith,
    keywords: ['pray', 'thanks', 'doa', 'syukur'],
  ),
  EventEmojiOption(
    emoji: '🕌',
    category: EventEmojiCategory.faith,
    keywords: ['mosque', 'islam', 'masjid'],
  ),
  EventEmojiOption(
    emoji: '⛪',
    category: EventEmojiCategory.faith,
    keywords: ['church', 'gereja'],
  ),
  EventEmojiOption(
    emoji: '🕯️',
    category: EventEmojiCategory.faith,
    keywords: ['candle', 'memorial', 'lilin', 'renungan'],
  ),
];

final eventEmojis = [
  for (final option in eventEmojiOptions) option.emoji,
];
