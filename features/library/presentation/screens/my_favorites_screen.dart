import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/app/router/app_router.dart';
import 'package:bookhub2/core/cart/cart_manager.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';

class MyFavoritesScreen extends StatelessWidget {
  const MyFavoritesScreen({super.key});

  Future<List<Map<String, dynamic>>> _loadFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'demo-user';
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('addedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'] ?? 'Untitled',
        'author': data['author'] ?? 'Unknown author',
        'price': (data['price'] as num?)?.toDouble() ?? 0.0,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Favorites', style: TextStyle(color: AppColors.navy)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border_rounded, size: 56, color: AppColors.actionBlue),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'No favorites yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Sign in to save favorite books, or keep browsing as a guest.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => context.go(AppRouter.home),
                  child: const Text('Continue shopping'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Favorites', style: TextStyle(color: AppColors.navy)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Unable to load favorites.'),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => context.go(AppRouter.home),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data ?? const <Map<String, dynamic>>[];

          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Your wishlist is empty.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.xl),
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = favorites[index];
              final title = item['title'] as String;
              final author = item['author'] as String;
              final price = (item['price'] as double).toStringAsFixed(0);

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
                      width: 64,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: const Icon(Icons.book_rounded, color: AppColors.actionBlue, size: 28),
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
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'EGP $price',
                            style: const TextStyle(
                              color: AppColors.actionBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.actionBlue),
                          onPressed: () {
                            CartManager.instance.addBook(
                              id: item['id'] as String,
                              name: title,
                              author: author,
                              price: (item['price'] as num).toDouble(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$title added to cart')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSecondary),
                          onPressed: () async {
                            final uid = FirebaseAuth.instance.currentUser?.uid ?? 'demo-user';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .collection('favorites')
                                .doc(item['id'] as String)
                                .delete();
                            if (context.mounted) {
                              context.go(AppRouter.favorites);
                            }
                          },
                        ),
                      ],
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
