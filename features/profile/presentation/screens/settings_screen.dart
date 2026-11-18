import 'package:flutter/material.dart';

import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/features/profile/data/repositories/user_profile_repository_impl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repository = UserProfileRepositoryImpl();
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Card(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: const Text('Dark mode'),
                  subtitle: const Text('Use a dark theme for the app'),
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                ),
                SwitchListTile.adaptive(
                  title: const Text('Notifications'),
                  subtitle: const Text('Receive updates and promotions'),
                  value: _notificationsEnabled,
                  onChanged: (value) => setState(() => _notificationsEnabled = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _SettingsSection(
            title: 'Support',
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy Policy'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_outline_rounded),
                title: const Text('Help Center'),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SettingsSection(
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                title: const Text('Delete Account'),
                textColor: AppColors.error,
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete account?'),
                      content: const Text(
                        'This action cannot be undone. Continue?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    try {
                      await _repository.deleteProfile('demo-user');
                    } catch (_) {
                      // Fallback for non-configured Firebase environments.
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
