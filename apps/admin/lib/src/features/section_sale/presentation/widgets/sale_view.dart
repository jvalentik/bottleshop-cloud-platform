import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/product_card.dart';
import 'package:bottleshop_admin/src/features/section_sale/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/section_sale/presentation/widgets/product_card_sale_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class SaleView extends HookWidget {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    final productsState = useProvider(
      saleProductsProvider.select((value) => value.itemsState),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomScrollView(
        slivers: [
          _InitialItem(),
          SliverPagedList(
            itemsState: productsState,
            itemBuilder: (context, dynamic item, _) => ProductCard(
              product: item,
              productCardMenuButtonBuilder: (_) =>
                  ProductCardSaleMenuButton(item),
            ),
            requestData: () {},
          )
        ],
      ),
    );
  }
}

class _InitialItem extends StatelessWidget {
  const _InitialItem();

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Výpredaj',
              style: AppTheme.headline1TextStyle,
            ),
            Row(
              children: [
                Text(
                  'Pre pridanie produktu pokračujte cez produkty',
                  style: AppTheme.subtitle1TextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.widgets,
                    color: AppTheme.mediumGreySolid,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      );
}
