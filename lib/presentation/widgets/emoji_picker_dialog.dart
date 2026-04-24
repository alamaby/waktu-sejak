import 'package:flutter/material.dart';

const _emojis = [
  '🎂', '🎓', '💍', '✈️', '🏠', '🚀', '🎉', '🏆',
  '💪', '❤️', '🌟', '🎵', '📅', '💼', '🐶', '🌏',
  '🔥', '🏋️', '🎮', '📚', '☕', '🌈', '🎸', '🍕',
  '🌺', '⚽', '🎯', '🧘', '🏖️', '🦋', '🎪', '🧩',
];

class EmojiPickerDialog extends StatelessWidget {
  final String selectedEmoji;

  const EmojiPickerDialog({super.key, required this.selectedEmoji});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pick an Emoji',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojis.map((emoji) {
                final isSelected = emoji == selectedEmoji;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(emoji),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showEmojiPicker(
  BuildContext context, {
  required String currentEmoji,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => EmojiPickerDialog(selectedEmoji: currentEmoji),
  );
}
