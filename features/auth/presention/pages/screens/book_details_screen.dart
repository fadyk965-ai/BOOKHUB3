import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookhub2/core/app/router/app_router.dart';
import 'package:bookhub2/core/cart/cart_manager.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/core/widgets/app_button.dart';

/// [BookDetailsScreen] تعرض التفاصيل الكاملة للكتاب المحدد بناءً على المعرف [bookId]
class BookDetailsScreen extends StatelessWidget {
  final String bookId;

  const BookDetailsScreen({
    super.key,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية مؤقتة يتم جلبها عادة عبر الـ ID
    const String bookTitle = 'Clean Architecture: A Craftsman\'s Guide';
    const String bookAuthor = 'Robert C. Martin';
    const String bookPrice = '\$29.99';
    const double bookRating = 4.8;
    const String bookDescription =
        'By even better understanding how software architects think and work, you can dramatically improve your productivity and code quality. Clean Architecture is the logical culmination of decades of experience and advice across programming paradigms.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navy),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.navy),
            onPressed: () {
              // إضافة للمفضلة مستقبلاً
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to favorites')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // غلاف الكتاب التجريبي
              Center(
                child: Container(
                  height: 260,
                  width: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.book_rounded,
                      size: 80,
                      color: AppColors.actionBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // عنوان الكتاب
              Text(
                bookTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.actionBlue,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // اسم المؤلف
              Text(
                'By $bookAuthor',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // التقييم والسعر
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '$bookRating',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  Text(
                    bookPrice,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.actionBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // نبذة عن الكتاب
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                bookDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // زر إضافة إلى عربة التسوق
              AppButton(
                text: 'Add to Cart',
                onPressed: () {
                  CartManager.instance.addBook(
                    id: bookId,
                    name: bookTitle,
                    author: bookAuthor,
                    price: 29.99,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book added to cart successfully!')),
                  );
                  context.push(AppRouter.cart);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
