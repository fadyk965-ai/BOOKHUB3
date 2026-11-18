import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/app/app_shell.dart';
import 'package:bookhub2/core/config/app_mode.dart';
import 'package:bookhub2/features/auth/presention/pages/screens/book_details_screen.dart';
import 'package:bookhub2/features/auth/presention/pages/screens/checkout_screen.dart';
import 'package:bookhub2/features/auth/presention/pages/screens/login_screen.dart';
import 'package:bookhub2/features/auth/presention/pages/screens/register_screen.dart';
import 'package:bookhub2/features/library/presentation/screens/my_library_screen.dart';
import 'package:bookhub2/features/library/presentation/screens/my_orders_screen.dart';
import 'package:bookhub2/features/profile/presentation/screens/settings_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

abstract final class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String bookDetails = '/book/:bookId';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String library = '/library';
  static const String favorites = '/favorites';
  static const String myOrders = '/my-orders';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static String bookDetailsPath(String bookId) => '/book/$bookId';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    redirect: (context, state) {
      if (AppMode.isDemo) return null;
      final currentUser = FirebaseAuth.instance.currentUser;
      final path = state.uri.path;
      final isAuthRoute = path == login || path == register;
      final isProtectedRoute = {
        library,
        profile,
        settings,
      }.contains(path);
      final isGuestAllowedRoute = {
        cart,
        checkout,
        myOrders,
        favorites,
      }.contains(path);

      if (!isAuthRoute && isProtectedRoute && currentUser == null) {
        return login;
      }

      if (isGuestAllowedRoute) {
        return null;
      }

      if (isAuthRoute && currentUser != null) {
        return home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainBookHubShell(initialIndex: 0),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: bookDetails,
        name: 'bookDetails',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId'] ?? '';
          return BookDetailsScreen(bookId: bookId);
        },
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const MainBookHubShell(initialIndex: 2),
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: library,
        name: 'library',
        builder: (context, state) => const MyLibraryScreen(),
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (context, state) => const MainBookHubShell(initialIndex: 1),
      ),
      GoRoute(
        path: myOrders,
        name: 'myOrders',
        builder: (context, state) => const MyOrdersScreen(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const MainBookHubShell(initialIndex: 3),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404 - Page Not Found!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go Back to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

