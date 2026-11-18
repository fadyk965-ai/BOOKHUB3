import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/app/router/app_router.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/features/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:bookhub2/features/profile/domain/entities/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileRepositoryImpl _repository = UserProfileRepositoryImpl();
  late Future<UserProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<UserProfile> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? 'demo-user';

    try {
      final profile = await _repository.getProfile(uid);
      if (profile.uid.isEmpty) {
        return UserProfile.empty(uid);
      }
      return profile;
    } catch (_) {
      return UserProfile.empty(uid);
    }
  }

  Future<void> _saveProfile(UserProfile currentProfile) async {
    try {
      await _repository.updateProfile(currentProfile.uid, currentProfile.toMap());
    } catch (_) {
      // Firebase not configured in the local stub environment.
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // ignore local auth cleanup issues
    }
    if (mounted) {
      context.go(AppRouter.login);
    }
  }

  void _editProfile(UserProfile currentProfile) async {
    final nameController = TextEditingController(text: currentProfile.displayName);
    final emailController = TextEditingController(text: currentProfile.email);
    final phoneController = TextEditingController(text: currentProfile.phoneNumber);
    final bioController = TextEditingController(text: currentProfile.bio);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Display name'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) {
      return;
    }

    final updated = UserProfile(
      uid: currentProfile.uid,
      displayName: nameController.text.trim().isNotEmpty
          ? nameController.text.trim()
          : currentProfile.displayName,
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim()
          : currentProfile.email,
      avatarUrl: currentProfile.avatarUrl,
      phoneNumber: phoneController.text.trim(),
      bio: bioController.text.trim(),
      notificationsEnabled: currentProfile.notificationsEnabled,
      darkMode: currentProfile.darkMode,
    );

    setState(() {
      _profileFuture = Future.value(updated);
    });

    await _saveProfile(updated);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline_rounded, size: 52, color: AppColors.actionBlue),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Guest mode active',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'You can still browse and place orders without logging in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => context.go(AppRouter.home),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Profile unavailable. Please try again later.'),
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.actionBlue,
                    backgroundImage: profile.avatarUrl.isNotEmpty ? NetworkImage(profile.avatarUrl) : null,
                    child: profile.avatarUrl.isEmpty
                        ? Text(
                            profile.displayName.isNotEmpty ? profile.displayName.substring(0, 1).toUpperCase() : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  profile.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  profile.email,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        label: 'Phone',
                        value: profile.phoneNumber.isNotEmpty ? profile.phoneNumber : 'Not provided',
                      ),
                      const Divider(height: AppSpacing.xl),
                      _InfoRow(
                        label: 'Bio',
                        value: profile.bio.isNotEmpty ? profile.bio : 'No bio added yet',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _editProfile(profile),
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(AppRouter.settings),
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Settings'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
