import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/adaptive_bottom_navigation_scaffold.dart';
import 'package:delivery/src/core/presentation/widgets/bottom_navigation_tab.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/cart_icon_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeMobileScaffold extends HookWidget {
  const HomeMobileScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveBottomNavigationScaffold(
      navigationBarItems: [
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.l10n.homeTabLabel,
          ),
          navigationNestingLevel: NestingBranch.shop,
          // navigatorKey: homeTabKey,
          // scaffoldKey:
          //     homeScaffoldKey, // TODO: this scaffold key is not connected
          // initialPageBuilder: (context) =>
          //     Container() // TODO: const ProductsPage(),
        ),
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.liquor),
            label: context.l10n.categories,
          ),
          navigationNestingLevel: NestingBranch.categories,
          // navigatorKey: categoriesTabKey,
          // scaffoldKey: categoriesScaffoldKey,
          // initialPageBuilder: (context) => const CategoryTab(),
        ),
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: context.l10n.favoriteTabLabel,
          ),
          navigationNestingLevel: NestingBranch.favorites,
          // navigatorKey: favoriteTabKey,
          // scaffoldKey: favoriteScaffoldKey,
          // initialPageBuilder: (context) => const FavoritesTab(),
        ),
        BottomNavigationTab(
          bottomNavigationBarItem: BottomNavigationBarItem(
            icon: const CartIconWithBadge(),
            label: context.l10n.shopping_cart,
          ),
          navigationNestingLevel: NestingBranch.cart,
          // navigatorKey: cartTabKey,
          // scaffoldKey: cartScaffoldKey,
          // initialPageBuilder: (context) => const CartTab(),
        ),
      ],
    );
  }
}
