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
import 'package:delivery/src/features/home/presentation/slivers/sliver_products_heading_tile.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/presentation/slivers/sliver_products_list.dart';
import 'package:delivery/src/features/sticky_header/presentation/widgets/categories_sticky_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SliverAllProducts extends HookWidget {
  const SliverAllProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverProductsHeadingTile(
            title: context.l10n.allProducts,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const _AllProductsList(),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );

    if (kIsWeb) {
      return child;
    } else {
      return SliverStickyHeader(
        header: const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 12),
          child: CategoriesStickyHeader(),
        ),
        sliver: child,
      );
    }
  }
}

class _AllProductsList extends HookConsumerWidget {
  const _AllProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState =
        ref.watch(allProductsProvider.select((value) => value.itemsState));

    return SliverProductsList(
      productsState: productsState,
      requestData: () => ref.read(allProductsProvider).requestData(),
    );
  }
}
