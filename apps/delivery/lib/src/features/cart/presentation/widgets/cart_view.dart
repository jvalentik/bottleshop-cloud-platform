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

import 'dart:convert';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/cart/presentation/widgets/cart_list_item.dart';
import 'package:delivery/src/features/checkout/presentation/pages/checkout_page.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/checkout_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routeborn/routeborn.dart';

import '../../../checkout/presentation/pages/stripe_checkout_success.dart';

final _logger = Logger((CartView).toString());

class CartView extends HookConsumerWidget {
  const CartView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Column(
      children: <Widget>[
        Expanded(
          child: CupertinoScrollbar(
            controller: scrollController,
            thumbVisibility: false,
            child: ref.watch(cartProvider).when(
                  data: (cart) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: cart.products.length,
                      itemBuilder: (context, index) => Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) async {
                          await ref.read(cartRepositoryProvider)!.removeItem(
                              cart.products.elementAt(index).product.uniqueId);
                          showSimpleNotification(
                            Text(context.l10n.itemRemovedFromCart),
                            position: NotificationPosition.bottom,
                            duration: const Duration(seconds: 1),
                            slideDismissDirection: DismissDirection.horizontal,
                            context: context,
                          );
                        },
                        child: CartListItem(
                          product: cart.products.elementAt(index).product,
                          quantity: cart.products.elementAt(index).count,
                        ),
                      ),
                    );
                  },
                  loading: () => const Loader(),
                  error: (err, stack) {
                    _logger.severe('Failed to fetch cart content', err, stack);
                    return Center(
                      child: Text(context.l10n.failedToFetchCart),
                    );
                  },
                ),
          ),
        ),
        ref.watch(cartProvider).when(
              data: (cart) {
                return CheckoutTile(
                  actionLabel: context.l10n.proceedToShipment,
                  actionCallback: () async {
                    var items = [...cart.products.toList()];
                    final productJsonList = items.map((e) {
                      return {'name': e.product.name, 'count': e.count};
                    }).toList();
                    ref.read(orderCartProvider.state).state =
                        jsonEncode(productJsonList);
                    ref.read(navigationProvider).pushPage(
                          context,
                          AppPageNode(page: CheckoutPage()),
                        );
                  },
                );
              },
              loading: () => const Loader(),
              error: (err, stack) {
                _logger.severe('Failed to fetch cart', err, stack);
                return Center(
                  child: Text(context.l10n.error),
                );
              },
            ),
      ],
    );
  }
}
