import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/features/profile/data/repositories/user_profile_repository_impl.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  final _repository = UserProfileRepositoryImpl();
  late Future<List<Map<String, dynamic>>> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = _repository.getLibrary('demo-user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _libraryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Unable to load your library.'),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _libraryFuture = _repository.getLibrary('demo-user');
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final books = snapshot.data ?? const <Map<String, dynamic>>[];

          if (books.isEmpty) {
            return const Center(
              child: Text(
                'Your library is empty.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.xl),
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final book = books[index];
              final title = (book['title'] as String?) ?? 'Untitled';
              final author = (book['author'] as String?) ?? 'Unknown';
              final purchasedAt = (book['purchasedAt'] as Timestamp?)?.toDate();

              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.actionBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            author,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            purchasedAt == null
                                ? 'Purchased recently'
                                : 'Purchased: ${purchasedAt.day}/${purchasedAt.month}/${purchasedAt.year}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
