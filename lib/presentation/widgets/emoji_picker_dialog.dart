import 'package:flutter/material.dart';

import '../../core/constants/event_emojis.dart';
import '../../core/l10n/generated/app_localizations.dart';

class EmojiPickerDialog extends StatefulWidget {
  final String selectedEmoji;
  final List<String> recentEmojis;

  const EmojiPickerDialog({
    super.key,
    required this.selectedEmoji,
    this.recentEmojis = const [],
  });

  @override
  State<EmojiPickerDialog> createState() => _EmojiPickerDialogState();
}

class _EmojiPickerDialogState extends State<EmojiPickerDialog> {
  final _searchController = TextEditingController();

  EventEmojiCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.recentEmojis.isEmpty ? EventEmojiCategory.popular : null;
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _searchController.text.trim();
    final visibleEmojis = _visibleEmojis(query);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.emojiLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('emoji_search_field'),
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchEmoji,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        key: const Key('emoji_search_clear_button'),
                        onPressed: _searchController.clear,
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            if (query.isEmpty) ...[
              _CategorySelector(
                selectedCategory: _selectedCategory,
                hasRecent: widget.recentEmojis.isNotEmpty,
                onSelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
              const SizedBox(height: 12),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: visibleEmojis.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          l10n.noEmojiResults,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: visibleEmojis.map((emoji) {
                          return _EmojiTile(
                            emoji: emoji,
                            isSelected: emoji == widget.selectedEmoji,
                            onTap: () => Navigator.of(context).pop(emoji),
                          );
                        }).toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            TextButton(
              key: const Key('emoji_picker_cancel_button'),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _visibleEmojis(String query) {
    if (query.isNotEmpty) {
      return [
        for (final option in eventEmojiOptions)
          if (option.matches(query)) option.emoji,
      ];
    }

    if (_selectedCategory == null) {
      return widget.recentEmojis;
    }

    return [
      for (final option in eventEmojiOptions)
        if (option.category == _selectedCategory) option.emoji,
    ];
  }
}

class _CategorySelector extends StatelessWidget {
  final EventEmojiCategory? selectedCategory;
  final bool hasRecent;
  final ValueChanged<EventEmojiCategory?> onSelected;

  const _CategorySelector({
    required this.selectedCategory,
    required this.hasRecent,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      if (hasRecent) null,
      EventEmojiCategory.popular,
      EventEmojiCategory.personal,
      EventEmojiCategory.travel,
      EventEmojiCategory.vehicle,
      EventEmojiCategory.work,
      EventEmojiCategory.health,
      EventEmojiCategory.home,
      EventEmojiCategory.faith,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final category in categories) ...[
            ChoiceChip(
              key: Key('emoji_category_${category?.name ?? 'recent'}'),
              label: Text(_categoryLabel(context, category)),
              selected: selectedCategory == category,
              onSelected: (_) => onSelected(category),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  String _categoryLabel(BuildContext context, EventEmojiCategory? category) {
    final l10n = AppLocalizations.of(context);
    return switch (category) {
      null => l10n.emojiCategoryRecent,
      EventEmojiCategory.popular => l10n.emojiCategoryPopular,
      EventEmojiCategory.personal => l10n.emojiCategoryPersonal,
      EventEmojiCategory.travel => l10n.emojiCategoryTravel,
      EventEmojiCategory.vehicle => l10n.emojiCategoryVehicle,
      EventEmojiCategory.work => l10n.emojiCategoryWork,
      EventEmojiCategory.health => l10n.emojiCategoryHealth,
      EventEmojiCategory.home => l10n.emojiCategoryHome,
      EventEmojiCategory.faith => l10n.emojiCategoryFaith,
    };
  }
}

class _EmojiTile extends StatelessWidget {
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmojiTile({
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('emoji_tile_$emoji'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
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
  }
}

Future<String?> showEmojiPicker(
  BuildContext context, {
  required String currentEmoji,
  List<String> recentEmojis = const [],
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => EmojiPickerDialog(
      selectedEmoji: currentEmoji,
      recentEmojis: recentEmojis,
    ),
  );
}
