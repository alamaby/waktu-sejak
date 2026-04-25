import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/social_links.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _SectionCard(
            title: l10n.language,
            icon: Icons.language,
            child: SegmentedButton<Locale>(
              expandedInsets: EdgeInsets.zero,
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: const Locale('en'),
                  label: Text(l10n.english),
                  icon: const Text('🇬🇧'),
                ),
                ButtonSegment(
                  value: const Locale('id'),
                  label: Text(l10n.indonesian),
                  icon: const Text('🇮🇩'),
                ),
              ],
              selected: {locale},
              onSelectionChanged: (selected) {
                ref
                    .read(localeNotifierProvider.notifier)
                    .setLocale(selected.first);
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Theme Section
          _SectionCard(
            title: l10n.theme,
            icon: Icons.palette_outlined,
            child: SegmentedButton<ThemeMode>(
              expandedInsets: EdgeInsets.zero,
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selected) {
                ref
                    .read(themeModeNotifierProvider.notifier)
                    .setThemeMode(selected.first);
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          _SectionCard(
            title: l10n.about,
            icon: Icons.info_outline,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: l10n.authorLabel,
                  value: l10n.authorName,
                ),
                const SizedBox(height: 4),
                const _InfoRow(
                  label: 'App Version',
                  value: '1.0.0',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Links Section
          _SectionCard(
            title: l10n.links,
            icon: Icons.link,
            child: Column(
              children: [
                _LinkTile(
                  icon: Icons.work_outline,
                  label: l10n.linkedin,
                  url: SocialLinks.linkedin,
                  context: context,
                ),
                _LinkTile(
                  icon: Icons.code,
                  label: l10n.github,
                  url: SocialLinks.github,
                  context: context,
                ),
                _LinkTile(
                  icon: Icons.article_outlined,
                  label: l10n.blog,
                  url: SocialLinks.blog,
                  context: context,
                ),
                _LinkTile(
                  icon: Icons.business_center_outlined,
                  label: l10n.upwork,
                  url: SocialLinks.upwork,
                  context: context,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Donations Section
          _SectionCard(
            title: l10n.donate,
            icon: Icons.favorite_outline,
            child: Column(
              children: [
                _LinkTile(
                  icon: Icons.coffee_outlined,
                  label: l10n.buyMeCoffee,
                  url: SocialLinks.buyMeCoffee,
                  context: context,
                ),
                _LinkTile(
                  icon: Icons.volunteer_activism_outlined,
                  label: l10n.saweria,
                  url: SocialLinks.saweria,
                  context: context,
                ),
                _LinkTile(
                  icon: Icons.star_outline,
                  label: l10n.patreon,
                  url: SocialLinks.patreon,
                  context: context,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Text(
              '© 2025 Alam Aby Bashit',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final BuildContext context;

  const _LinkTile({
    required this.icon,
    required this.label,
    required this.url,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label),
      trailing: const Icon(Icons.open_in_new, size: 16),
      onTap: () async {
        final messenger = ScaffoldMessenger.of(context);
        final uri = Uri.tryParse(url);
        final ok = uri != null &&
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!ok) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.couldNotOpenLink),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}
