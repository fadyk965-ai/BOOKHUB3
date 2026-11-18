import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/di/service_locator.dart';
import 'package:bookhub2/core/config/app_mode.dart';
import 'package:bookhub2/core/cart/cart_manager.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/core/widgets/app_button.dart';
import 'package:bookhub2/core/widgets/app_text_field.dart';

import '../../../../../core/app/router/app_router.dart';
import '../../../../checkout/domain/entities/checkout_request.dart';
import '../../../../checkout/domain/usecases/place_order.dart';

/// [CheckoutScreen] شاشة إتمام الطلب وإدخال عنوان الشحن وطريقة الدفع
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseAuth _auth = services.auth;
  final PlaceOrder _placeOrderUseCase = services.placeOrder;

  String _selectedPaymentMethod = 'Cash on Delivery';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!mounted) return;

    setState(() => _isSubmitting = true);

    final String? uid = _auth.currentUser?.uid;

    try {
      if (AppMode.isDemo) {
        if (CartManager.instance.items.isEmpty) throw StateError('Your cart is empty.');
        CartManager.instance.clearCart();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo order placed. Firebase is not used.')));
        context.go(AppRouter.home);
        return;
      }
      if (uid == null) throw StateError('Please sign in before checkout.');
      final orderId = await _placeOrderUseCase(CheckoutRequest(
        uid: uid,
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
      ));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order $orderId placed successfully.')));
      context.go(AppRouter.myOrders);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout error: ${error.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navy),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _addressController,
                  label: 'Street Address, City',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your shipping address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: AppSpacing.md),

                RadioGroup<String>(
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Cash on Delivery'),
                          value: 'Cash on Delivery',
                          activeColor: AppColors.actionBlue,
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                AppButton(
                  text: 'Place Order',
                  onPressed: _isSubmitting ? null : _placeOrder,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
