import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookhub2/core/app/router/app_router.dart';
import 'package:bookhub2/core/cart/cart_manager.dart';
import 'package:bookhub2/core/theme/app_colors.dart';
import 'package:bookhub2/core/theme/app_spacing.dart';
import 'package:bookhub2/core/widgets/app_text_field.dart';
import 'package:bookhub2/core/widgets/book_card.dart';
import 'package:bookhub2/core/widgets/category_chip.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final GlobalKey _cartIconKey = GlobalKey();
  final Map<int, GlobalKey> _bookKeys = {};
  OverlayEntry? _activeFlyingEntry;

  void _addBookToCart({
    required BuildContext context,
    required int index,
    required String bookId,
    required String title,
    required String author,
    required double price,
  }) {
    CartManager.instance.addBook(
      id: bookId,
      name: title,
      author: author,
      price: price,
    );

    _animateAddToCart(context, index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title added to cart'),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _animateAddToCart(BuildContext pageContext, int index) {
    final itemKey = _bookKeys.putIfAbsent(index, () => GlobalKey());
    final itemContext = itemKey.currentContext;
    final cartContext = _cartIconKey.currentContext;

    if (itemContext == null || cartContext == null) {
      return;
    }

    final itemBox = itemContext.findRenderObject() as RenderBox;
    final cartBox = cartContext.findRenderObject() as RenderBox;
    final startRect = itemBox.localToGlobal(Offset.zero) & itemBox.size;
    final endRect = cartBox.localToGlobal(Offset.zero) & cartBox.size;

    final overlay = Overlay.of(pageContext, rootOverlay: true);
    final entry = OverlayEntry(
      builder: (_) => _FlyingCartOverlay(
        startRect: startRect,
        endRect: endRect,
        child: Container(
          width: startRect.width,
          height: startRect.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8E1D6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.book_rounded,
              color: AppColors.navy,
              size: 18,
            ),
          ),
        ),
        onComplete: () {
          _activeFlyingEntry?.remove();
          _activeFlyingEntry = null;
        },
      ),
    );

    _activeFlyingEntry?.remove();
    _activeFlyingEntry = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isPhone = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1100;
    final horizontalPadding = isPhone ? AppSpacing.xl : AppSpacing.xxl;

    final booksData = [
      {'title': 'Atomic Habits', 'author': 'James Clear', 'price': 390.0},
      {'title': 'Deep Work', 'author': 'Cal Newport', 'price': 430.0},
      {'title': 'The Pragmatic Programmer', 'author': 'Andrew Hunt', 'price': 520.0},
      {'title': 'Clean Code', 'author': 'Robert C. Martin', 'price': 480.0},
      {'title': 'The Alchemist', 'author': 'Paulo Coelho', 'price': 280.0},
      {'title': 'Ikigai', 'author': 'Héctor García', 'price': 340.0},
      {'title': 'The Lean Startup', 'author': 'Eric Ries', 'price': 360.0},
      {'title': 'Rich Dad Poor Dad', 'author': 'Robert T. Kiyosaki', 'price': 310.0},
      {'title': 'The Midnight Library', 'author': 'Matt Haig', 'price': 410.0},
      {'title': 'The Psychology of Money', 'author': 'Morgan Housel', 'price': 330.0},
      {'title': 'JavaScript: The Good Parts', 'author': 'Douglas Crockford', 'price': 470.0},
      {'title': 'Big Magic', 'author': 'Elizabeth Gilbert', 'price': 310.0},
    ];

    final arrivalData = [
      {'title': 'Thinking, Fast and Slow', 'author': 'Daniel Kahneman', 'price': 460.0},
      {'title': 'The Secret', 'author': 'Rhonda Byrne', 'price': 290.0},
      {'title': 'The Power of Habit', 'author': 'Charles Duhigg', 'price': 350.0},
      {'title': 'Cryptoassets', 'author': 'Chris Burniske', 'price': 520.0},
      {'title': 'Algorithms to Live By', 'author': 'Brian Christian', 'price': 440.0},
      {'title': 'The Kite Runner', 'author': 'Khaled Hosseini', 'price': 300.0},
    ];

    return AnimatedBuilder(
      animation: CartManager.instance,
      builder: (context, _) {
        final cartCount = CartManager.instance.itemCount;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F6F0),
          appBar: AppBar(
            title: const Text(
              'Welcome back',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            backgroundColor: const Color(0xFFF9F6F0),
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                onPressed: () => context.push(AppRouter.login),
                icon: const Icon(Icons.person_outline_rounded, color: AppColors.navy),
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    key: _cartIconKey,
                    onPressed: () => context.push(AppRouter.cart),
                    icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.navy),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.actionBlue,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$cartCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, AppSpacing.xl, horizontalPadding, AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.actionBlue,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.actionBlue.withValues(alpha: 0.25),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'F',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'let\'s read,',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Fady',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const AppTextField(
                    label: 'Search books, authors, and more',
                    prefixIcon: Icons.search_rounded,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Browse by category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.actionBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      CategoryChip(label: 'All', isSelected: true),
                      CategoryChip(label: 'Fiction', isSelected: false),
                      CategoryChip(label: 'Programming', isSelected: false),
                      CategoryChip(label: 'Business', isSelected: false),
                      CategoryChip(label: 'Self-Development', isSelected: false),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: 0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Featured pick',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text(
                                'Deep Work',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                'Unlock your focus and build lasting momentum.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Container(
                          width: 94,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            size: 46,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured books',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                          letterSpacing: -0.2,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.actionBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 330,
                    child: Stack(
                      children: [
                        ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: booksData.length,
                          padding: const EdgeInsets.only(right: AppSpacing.xl),
                          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final book = booksData[index];
                            final bookKey = _bookKeys.putIfAbsent(index, () => GlobalKey());

                            return SizedBox(
                              width: 180,
                              child: BookCard(
                                key: bookKey,
                                title: book['title'] as String,
                                author: book['author'] as String,
                                price: (book['price'] as num).toDouble(),
                                onAddToCart: () {
                                  _addBookToCart(
                                    context: context,
                                    index: index,
                                    bookId: 'featured-$index',
                                    title: book['title'] as String,
                                    author: book['author'] as String,
                                    price: (book['price'] as num).toDouble(),
                                  );
                                },
                                onTap: () => context.push('/book/$index'),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.navy.withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    'New arrivals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: arrivalData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPhone ? 1 : (isTablet ? 2 : 3),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: isPhone ? 2.8 : (isTablet ? 3.2 : 3.8),
                    ),
                    itemBuilder: (context, index) {
                      final item = arrivalData[index];
                      final arrivalKey = _bookKeys.putIfAbsent(100 + index, () => GlobalKey());

                      return InkWell(
                        key: arrivalKey,
                        onTap: () {
                          _addBookToCart(
                            context: context,
                            index: 100 + index,
                            bookId: 'arrival-$index',
                            title: item['title'] as String,
                            author: item['author'] as String,
                            price: (item['price'] as num).toDouble(),
                          );
                        },
                      borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.navy.withValues(alpha: 0.04),
                              blurRadius: 12,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: isPhone ? 84 : 90,
                              height: isPhone ? 112 : 120,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border, width: 1),
                              ),
                              child: const Icon(
                                Icons.book_rounded,
                                color: AppColors.actionBlue,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.navy,
                                        fontSize: 14,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      item['author'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'EGP ${(item['price'] as num).toInt()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.actionBlue,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          height: 34,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              _addBookToCart(
                                                context: context,
                                                index: 100 + index,
                                                bookId: 'arrival-$index',
                                                title: item['title'] as String,
                                                author: item['author'] as String,
                                                price: (item['price'] as num).toDouble(),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.actionBlue,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                                            label: const Text(
                                              'Add',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlyingCartOverlay extends StatefulWidget {
  const _FlyingCartOverlay({
    required this.startRect,
    required this.endRect,
    required this.child,
    required this.onComplete,
  });

  final Rect startRect;
  final Rect endRect;
  final Widget child;
  final VoidCallback onComplete;

  @override
  State<_FlyingCartOverlay> createState() => _FlyingCartOverlayState();
}

class _FlyingCartOverlayState extends State<_FlyingCartOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        final start = widget.startRect.center;
        final end = widget.endRect.center;

        final control1 = Offset(
          start.dx + ((end.dx - start.dx) * 0.35),
          start.dy - 120,
        );
        final control2 = Offset(
          start.dx + ((end.dx - start.dx) * 0.65),
          start.dy - 60,
        );

        final segment1 = Offset.lerp(start, control1, t)!;
        final segment2 = Offset.lerp(control1, control2, t)!;
        final segment3 = Offset.lerp(control2, end, t)!;
        final segment4 = Offset.lerp(segment1, segment2, t)!;
        final segment5 = Offset.lerp(segment2, segment3, t)!;
        final current = Offset.lerp(segment4, segment5, t)!;

        final size = widget.startRect.size;
        final opacity = 1.0 - (t * 0.9);
        final scale = 1.0 - (t * 0.3);

        return Positioned(
          left: current.dx - (size.width / 2),
          top: current.dy - (size.height / 2),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
