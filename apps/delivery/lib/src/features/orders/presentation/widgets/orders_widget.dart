// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/list_error_widget.dart';
import 'package:delivery/src/core/presentation/widgets/list_loading_widget.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/home/presentation/pages/home_page.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:delivery/src/features/orders/presentation/widgets/order_list_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class OrdersWidget extends HookConsumerWidget {
  final GlobalKey<AuthPopupButtonState> authButtonKey;

  const OrdersWidget(this.authButtonKey, {Key? key}) : super(key: key);

  static List<String> getOrderStepNames(BuildContext context) {
    return [
      context.l10n.orderCreated,
      context.l10n.orderReady,
      context.l10n.orderShipping,
      context.l10n.orderCompleted
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState =
        ref.watch(ordersProvider.select((value) => value.itemsState));

    final hasUser =
        ref.watch(currentUserProvider.select((value) => value != null));

    if (!hasUser) {
      return EmptyTab(
        icon: Icons.login,
        message: context.l10n.youNeedToLoginFirst,
        buttonMessage: context.l10n.login,
        onButtonPressed: () => authButtonKey.currentState!.showAccountMenu(),
      );
    } else if (ordersState.isDoneAndEmpty) {
      return EmptyTab(
          icon: Icons.fact_check_outlined,
          message: context.l10n.noOrders,
          buttonMessage: context.l10n.startExploring,
          onButtonPressed: () {
            ref
                .read(navigationProvider)
                .replaceRootStackWith([AppPageNode(page: HomePage())]);
          });
    } else {
      return CustomScrollView(
        slivers: [
          SliverPagedList(
            itemsState: ordersState,
            requestData: () => ref.read(ordersProvider).requestData(),
            itemBuilder: (context, dynamic item, _) => OrderListItem(
              order: item,
            ),
            errorWidgetBuilder: (context, onPressed) =>
                ListErrorWidget(onPressed),
            loadingWidgetBuilder: (_) => const ListLoadingWidget(),
          ),
        ],
      );
    }
  }
}
