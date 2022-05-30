import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/auth/presentation/widgets/views/auth_popup_button.dart';
import 'package:delivery/src/features/cart/presentation/providers/providers.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/molecules/add_to_cart_button.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/molecules/quantity_update_widget.dart';
import 'package:delivery/src/features/product_detail/presentation/widgets/molecules/toggle_wishlist_button.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

enum ProductAction {
  purchase,
  favorite,
}

class ProductActionsWidget extends HookConsumerWidget with UiLoggy {
  final ProductModel product;
  final GlobalKey<AuthPopupButtonState> authButtonKey;

  const ProductActionsWidget({
    Key? key,
    required this.product,
    required this.authButtonKey,
  }) : super(key: key);

  void needsLoginAlert(BuildContext context, ProductAction action) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          () {
            switch (action) {
              case ProductAction.purchase:
                return context.l10n.loginNeededForPurchase;
              case ProductAction.favorite:
                return context.l10n.loginNeededForFavorite;
            }
          }(),
        ),
        actions: [
          TextButton(
            child: Text(context.l10n.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text(context.l10n.login),
            onPressed: () {
              Navigator.of(context).pop();
              authButtonKey.currentState!.showAccountMenu();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUser =
        ref.watch(currentUserProvider.select<bool>((value) => value != null));

    return SizedBox(
      height: 42,
      child: ref.watch(isInCartStreamProvider(product)).maybeWhen(
            data: (isInCart) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ToggleWishlistButton(
                    product: product,
                    actionOverride: hasUser
                        ? null
                        : () =>
                            needsLoginAlert(context, ProductAction.favorite),
                  ),
                  const SizedBox(width: 10),
                  (isInCart ?? false)
                      ? Expanded(
                          child: QuantityUpdateWidget(
                            product: product,
                            actionOverride: hasUser
                                ? null
                                : () => needsLoginAlert(
                                    context, ProductAction.purchase),
                          ),
                        )
                      : Expanded(
                          child: AddToCartButton(
                            product: product,
                            actionOverride: hasUser
                                ? null
                                : () => needsLoginAlert(
                                    context, ProductAction.purchase),
                          ),
                        ),
                ],
              );
            },
            orElse: () => const Loader(),
            error: (err, stack) {
              loggy.error('Failed to fetch is item in cart', err, stack);
              return Text(context.l10n.error);
            },
          ),
    );
  }
}
