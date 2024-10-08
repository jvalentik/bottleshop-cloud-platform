import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/features/app_activity/presentation/app_activity.dart';
import 'package:bottleshop_admin/src/features/login/presentation/pages/intro_activity.dart';
import 'package:bottleshop_admin/src/features/order_detail/presentation/pages/order_detail_page.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/pages/product_edit_page.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NavigationNotifier extends StateNotifier<List<AppPage>> {
  NavigationNotifier(super.state);

  void pushPage(AppPage newPage) {
    state = [...state, newPage];
  }

  bool popPage([Object? argument]) {
    if (state.length > 1) {
      final lastPage = state.last;
      state = [...state]..removeLast();
      lastPage.onPopped?.call(argument);
      return true;
    } else {
      return true;
    }
  }

  void replaceLastWith(AppPage newPage) {
    state = [...state]
      ..removeLast()
      ..add(newPage);
  }

  void replaceAllWith(List<AppPage> newPages) {
    state = [...newPages];
  }

  void openOrder(
    String? orderUniqueId,
  ) {
    final introPage = IntroActivityPage(
      onPagesAfterLogin: () => [
        AppActivityPage(initialIndex: TabIndex.orders),
        OrderDetailPage(orderUniqueId: orderUniqueId),
      ],
    );

    // check if app is in on the login activity
    if (state.length == 1 && state.first.pageName == introPage.pageName) {
      state = [introPage];
    } else {
      state = [
        AppActivityPage(initialIndex: TabIndex.orders),
        OrderDetailPage(orderUniqueId: orderUniqueId)
      ];
    }
  }

  void openProduct(String? productUid) {
    final introPage = IntroActivityPage(
      onPagesAfterLogin: () => [
        AppActivityPage(initialIndex: TabIndex.products),
        ProductEditPage(
          productUid: productUid,
          productAction: ProductAction.editing,
        ),
      ],
    );

    if (state.length == 1 && state.first.pageName == introPage.pageName) {
      state = [introPage];
    } else {
      state = [
        AppActivityPage(initialIndex: TabIndex.products),
        ProductEditPage(
          productUid: productUid,
          productAction: ProductAction.editing,
        ),
      ];
    }
  }
}
