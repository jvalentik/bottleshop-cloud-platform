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
import 'package:delivery/src/core/data/models/category_model.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductHomeTab extends HookConsumerWidget {
  final ProductModel product;

  const ProductHomeTab({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(currentLanguageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          product.count > 0
              ? '${product.count} ${context.l10n.inStock}'
              : context.l10n.outOfStock,
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: product.count > 0 ? Colors.green : Colors.red),
          textAlign: TextAlign.right,
        ),
        // const SizedBox(height: 10),
        if (product.discount != null)
          Text(
            FormattingUtils.getPriceNumberString(
              product.priceWithVat,
              withCurrency: true,
            ),
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(decoration: TextDecoration.lineThrough),
          ),
        Text(
          FormattingUtils.getPriceNumberString(
            product.finalPrice,
            withCurrency: true,
          ),
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          title: Text(
            context.l10n.category,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _buildCategoryString(product.allCategories, currentLang),
            maxLines: 2,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        if (_buildExtraCategoryString(product.extraCategories, currentLang)
            .isNotEmpty) ...[
          const SizedBox(height: 20),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            title: Text(
              context.l10n.otherCategory,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _buildExtraCategoryString(product.extraCategories, currentLang),
              maxLines: 2,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ],
    );
  }

  String _buildCategoryString(
    List<CategoryModel> categories,
    LanguageMode currentLang,
  ) {
    var result = '';
    categories
        .where((category) => !category.categoryDetails.isExtraCategory)
        .forEach((category) {
      result += CategoryModel.allCategoryDetails(category)
          .map((e) => e.getName(currentLang))
          .join(' - ');
    });
    return result;
  }

  String _buildExtraCategoryString(
      List<CategoryModel>? extraCategories, LanguageMode currentLang) {
    var result = '';
    if (extraCategories != null) {
      extraCategories.forEach(
        (category) {
          result += CategoryModel.allCategoryDetails(category)
              .map((e) => e.getName(currentLang))
              .join(' - ');
        },
      );
    }
    return result;
  }
}
