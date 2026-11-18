import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/app/router/app_router.dart';
import 'package:bookhub2/core/cart/cart_manager.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/core/widgets/app_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CartManager.instance,
      builder: (context, _) {
        final cartItems = CartManager.instance.items;
        final subtotal = CartManager.instance.subtotal;
        final shipping = CartManager.instance.shipping;
        final total = CartManager.instance.total;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'My Cart',
              style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navy),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: cartItems.isEmpty
                ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            )
                : Column(
              children: [
                // القائمة الآن ستأخذ عرض الشاشة بالكامل وتتحرك بكرة الماوس من أقصى الحافة
                Expanded(
                  child: ListView.separated(
                    // أضفنا Padding داخلي للقائمة نفسها يمين ويسار وفوق وتهت لتكون منظمة
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
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
                              child: const Icon(Icons.book_rounded, color: AppColors.actionBlue, size: 32),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    item.author,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'EGP ${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.actionBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => CartManager.instance.removeItem(item.id),
                                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Row(
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => CartManager.instance.decreaseQuantity(item.id),
                                      icon: const Icon(Icons.remove, color: AppColors.navy),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => CartManager.instance.increaseQuantity(item.id),
                                      icon: const Icon(Icons.add, color: AppColors.navy),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // وضعنا الـ Padding هنا للأسفل والملخصات لكي تظل منظمة ولا تلتصق بحواف الشاشة بشكل سيء
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _SummaryRow(label: 'Subtotal', value: 'EGP ${subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: AppSpacing.sm),
                            _SummaryRow(label: 'Shipping', value: 'EGP ${shipping.toStringAsFixed(2)}'),
                            const Divider(height: AppSpacing.xl),
                            _SummaryRow(label: 'Total', value: 'EGP ${total.toStringAsFixed(2)}', bold: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        text: 'Proceed to Checkout',
                        onPressed: () => context.push(AppRouter.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? AppColors.navy : AppColors.textSecondary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}