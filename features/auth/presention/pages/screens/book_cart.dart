import 'package:flutter/material.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';

class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final double price;
  final VoidCallback? onAddToCart;
  final VoidCallback onTap;
  final GlobalKey? flyerKey;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    required this.price,
    this.onAddToCart,
    required this.onTap,
    this.flyerKey,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              key: widget.flyerKey,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(Icons.book_rounded, size: 40, color: AppColors.actionBlue),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.redAccent : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              widget.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EGP ${widget.price.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.actionBlue, fontSize: 13),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add_shopping_cart_rounded, color: AppColors.navy, size: 20),
                  onPressed: widget.onAddToCart,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}