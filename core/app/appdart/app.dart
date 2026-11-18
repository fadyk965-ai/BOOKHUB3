import 'package:flutter/material.dart';
import 'package:bookhub2/core/theme/app_colors.dart';

import '../router/app_router.dart';

/// [BookHubApp] هو الـ Widget الجذرية لتطبيق BookHub
/// تربط نظام التصميم (Material 3) ونظام التوجيه (GoRouter) معاً.
class BookHubApp extends StatelessWidget {
  const BookHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookHub',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.actionBlue,
          primary: AppColors.actionBlue,
        ),
      ),
    );
  }
}
