import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';
import '../widgets/color_picker_widget.dart';
import '../widgets/emoji_picker_dialog.dart';

const _uuid = Uuid();

const _defaultEmojis = [
  '🎂', '🎓', '💍', '✈️', '🏠', '🚀', '🎉', '🏆',
  '💪', '❤️', '🌟', '🎵', '📅', '💼', '🐶', '🌏',
  '🔥', '🏋️', '🎮', '📚', '☕', '🌈', '🎸', '🍕',
  '🌺', '⚽', '🎯', '🧘', '🏖️', '🦋', '🎪', '🧩',
];

class EventFormScreen extends ConsumerStatefulWidget {
  final EventModel? editingEvent;

  const EventFormScreen({super.key, this.editingEvent});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late DateTime _selectedDateTime;
  late String _selectedEmoji;
  late Color _selectedColor;

  bool get _isEditing => widget.editingEvent != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final e = widget.editingEvent!;
      _nameController.text = e.name;
      _selectedDateTime = e.targetDate;
      _selectedEmoji = e.emoji;
      _selectedColor = e.color;
    } else {
      _resetForm();
    }
  }

  void _resetForm() {
    final rand = Random();
    _selectedDateTime = DateTime.now();
    _selectedEmoji = _defaultEmojis[rand.nextInt(_defaultEmojis.length)];
    _selectedColor = AppColors.okabeIto[rand.nextInt(AppColors.paletteColorCount)];
    _nameController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickEmoji() async {
    final picked = await showEmojiPicker(
      context,
      currentEmoji: _selectedEmoji,
    );
    if (picked != null) {
      setState(() => _selectedEmoji = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(eventsNotifierProvider.notifier);

    if (_isEditing) {
      final updated = widget.editingEvent!.copyWith(
        name: _nameController.text.trim(),
        targetDate: _selectedDateTime,
        emoji: _selectedEmoji,
        color: _selectedColor,
      );
      notifier.updateEvent(updated);
      Navigator.of(context).pop();
      return;
    }

    final event = EventModel(
      id: _uuid.v4(),
      name: _nameController.text.trim(),
      targetDate: _selectedDateTime,
      emoji: _selectedEmoji,
      color: _selectedColor,
      createdAt: DateTime.now(),
    );

    notifier.addEvent(event);

    // Reset form for next use, then navigate to Dashboard
    _resetForm();
    if (mounted) setState(() {});
    ref.read(selectedTabProvider.notifier).select(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textColor = AppColors.textColorOn(_selectedColor);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editEvent : l10n.create)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Preview card
            _PreviewCard(
              emoji: _selectedEmoji,
              color: _selectedColor,
              textColor: textColor,
              name: _nameController.text.isEmpty
                  ? l10n.eventNameHint
                  : _nameController.text,
              dateTime: _selectedDateTime,
            ),
            const SizedBox(height: 24),

            // Event name
            Text(
              l10n.eventName,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(hintText: l10n.eventNameHint),
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.eventNameRequired;
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),

            // Date & time picker
            Text(
              l10n.dateAndTime,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            _DateTimeButton(
              dateTime: _selectedDateTime,
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 20),

            // Emoji picker
            Text(
              l10n.emojiLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickEmoji,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    _selectedEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Color picker
            Text(
              l10n.colorLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            ColorPickerWidget(
              selectedColor: _selectedColor,
              onColorSelected: (color) => setState(() => _selectedColor = color),
            ),
            const SizedBox(height: 32),

            // Save / Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(_isEditing ? l10n.update : l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String emoji;
  final Color color;
  final Color textColor;
  final String name;
  final DateTime dateTime;

  const _PreviewCard({
    required this.emoji,
    required this.color,
    required this.textColor,
    required this.name,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(dateTime),
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  $h:$m';
  }
}

class _DateTimeButton extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onTap;

  const _DateTimeButton({required this.dateTime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _formatDateTime(dateTime),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  at $h:$m';
  }
}
