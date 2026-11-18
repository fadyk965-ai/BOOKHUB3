import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// [AppButton] هو زر موحد لكل حالات التطبيق (أساسي، ثانوي، أو بأطراف محددة)
/// يلتزم بقاعدة الارتفاع الأدنى (48px) لسهولة الاستخدام باللمس، ويدعم حالة التحميل (Loading).
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد الشكل واللون بناءً على كون الزر أساسياً (Filled) أو إطاراً (Outlined)
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.minTapHeight, // الارتفاع الأدنى 48px لضمان متطلبات الـ Accessibility
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.actionBlue,
          side: const BorderSide(color: AppColors.actionBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
        child: _buildChild(),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.actionBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabledBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
        ),
        child: _buildChild(),
      ),
    );
  }

  /// دالة مساعدة لتبديل المحتوى بين النص أو مؤشر التحميل (Loading Spinner)
  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}