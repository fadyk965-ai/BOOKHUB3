import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/features/auth/presention/pages/screens/cart_screen.dart';
import 'package:bookhub2/features/auth/presention/pages/screens/home_dashboard_screen.dart';
import 'package:bookhub2/features/profile/presentation/screens/profile_screen.dart';
import 'package:bookhub2/features/library/presentation/screens/my_favorites_screen.dart';

import 'router/app_router.dart';

class MainBookHubShell extends StatefulWidget {
  const MainBookHubShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainBookHubShell> createState() => _MainBookHubShellState();
}

class _MainBookHubShellState extends State<MainBookHubShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final pages = const <Widget>[
      HomeDashboardScreen(),
      MyFavoritesScreen(),
      CartScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            height: 74,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              if (index == _selectedIndex) {
                return;
              }
              setState(() => _selectedIndex = index);

              switch (index) {
                case 0:
                  context.go(AppRouter.home);
                  break;
                case 1:
                  context.go(AppRouter.favorites);
                  break;
                case 2:
                  context.go(AppRouter.cart);
                  break;
                case 3:
                  context.go(AppRouter.profile);
                  break;
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
