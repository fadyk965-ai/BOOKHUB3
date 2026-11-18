import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/core/widgets/app_button.dart';
import 'package:bookhub2/core/widgets/app_text_field.dart';

import '../../../../../core/app/router/app_router.dart';

/// [LoginScreen] هي شاشة تسجيل الدخول للمستخدمين
/// تحتوي على نموذج إدخال مع التحقق من صحة البريد الإلكتروني وكلمة المرور.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // مفتاح النموذج للتحقق من صحة المدخلات (Form Validation Key)
  final _formKey = GlobalKey<FormState>();

  // وحدات تحكم لحقول النص
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email == 'demo@bookhub.com' && password == '123456') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Demo login successful')),
        );
        context.go(AppRouter.home);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use demo email: demo@bookhub.com and password: 123456')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // شعار أو أيقونة الترحيب
                    const Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.actionBlue,
                        child: Icon(Icons.menu_book_rounded, size: 36, color: Colors.white),


                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      'Welcome back to BookHub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Please enter your details to sign in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Demo login: demo@bookhub.com / 123456',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.actionBlue,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // حقل البريد الإلكتروني مع Validator
                    AppTextField(
                      controller: _emailController,
                      label: 'Email address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // حقل كلمة المرور مع Validator وإخفاء/إظهار النص
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // زر تسجيل الدخول
                    AppButton(
                      text: 'Sign In',
                      onPressed: _onLoginPressed,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // رابط الانتقال لإنشاء حساب جديد
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRouter.register),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: AppColors.actionBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}