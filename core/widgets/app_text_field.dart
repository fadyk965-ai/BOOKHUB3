import 'package:flutter/material.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';

/// [AppTextField] هو حقل إدخال مخصص وموحد لجميع نماذج التطبيق
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  // أضفنا هذه الخاصية للأيقونة الجانبية (مثل إظهار/إخفاء كلمة المرور)
  final bool obscureText;
  // أضفنا هذه الخاصية لإخفاء النص (لكلمات المرور)
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false, // القيمة الافتراضية نص عادي
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textSecondary) : null,
        suffixIcon: suffixIcon, // تمرير الأيقونة الجانبية
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.actionBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}