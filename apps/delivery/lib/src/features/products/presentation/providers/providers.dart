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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/core/data/models/preferences.dart';
import 'package:delivery/src/core/data/repositories/common_data_repository.dart';
import 'package:delivery/src/core/data/services/database_service.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/data/change_status.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/presentation/view_models/implementations/paged_streams_items_state_notifier.dart';
import 'package:delivery/src/core/utils/firestore_json_parsing_util.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/data/repositories/product_repository.dart';
import 'package:delivery/src/features/products/data/services/product_search_service.dart';
import 'package:delivery/src/features/products/presentation/view_models/products_state_notifier.dart';
import 'package:delivery/src/features/sorting/presentation/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final productsLayoutModeProvider = StateProvider<SupportedLayoutMode>((_) => SupportedLayoutMode.grid);

final productsService = Provider.autoDispose<DatabaseService<ProductModel>>(
  (_) => DatabaseService<ProductModel>(
    FirestoreCollections.productsCollection,
    fromMapAsync: (id, data) => FirestoreJsonParsingUtil.parseProductJson(data),
    toMap: (product) => product.toFirebaseJson(),
  ),
);

final productsRepositoryProvider = Provider.autoDispose<ProductsRepository>(
  (ref) => ProductsRepository(ref.watch(productsService)),
);

final productProvider = StreamProvider.autoDispose
    .family<ProductModel?, String>((ref, uid) => ref.watch(productsRepositoryProvider).streamProduct(uid));

/// When the category family is null, then products from all categories are queried.
final filteredProductsProvider =
    ChangeNotifierProvider.autoDispose.family<PagedProductsStateNotifier<int>, CategoryPlainModel?>(
  (ref, category) {
    final sortModel = ref.watch(sortModelProvider.state).state;

    return PagedProductsStateNotifier(
      (lastPageFetched) {
        final newPageId = lastPageFetched == null ? 0 : (lastPageFetched + 1);
        final currentAppliedFilter = ref
            .watch(
              appliedFilterProvider(
                category == null ? FilterType.allProducts : FilterType.categoryProducts,
              ).state,
            )
            .state;

        if (currentAppliedFilter.isAnyFilterActive) {
          final literUnit = ref
              .watch(commonDataRepositoryProvider.select((value) => value.data.units))
              .where((element) => element.id == '977qijBvm7cxuqPNgvb1') // liter unit id
              .first;

          return Stream.fromFuture(
            ProductsSearchService.filterProducts(
              currentAppliedFilter.getQuery(
                literUnit,
                onlyCategory: category,
              ),
              10,
              newPageId,
              sortModel,
            ),
          ).map(
            (event) => PagedItemsStateStreamBatch(
              Iterable<int>.generate(event.length)
                  .map(
                    (itemIndex) => Tuple3<ChangeStatus, int, ProductModel>(
                      ChangeStatus.added,
                      newPageId,
                      event[itemIndex],
                    ),
                  )
                  .toList(),
            ),
          );
        } else {
          return const Stream.empty();
        }
      },
      sortModel,
    )..requestData();
  },
);

final allProductsProvider = ChangeNotifierProvider.autoDispose<PagedProductsStateNotifier<DocumentSnapshot>>(
  (ref) {
    final sortModel = ref.watch(sortModelProvider.state).state;

    return PagedProductsStateNotifier(
      (lastDoc) => ref.watch(productsRepositoryProvider).getAllProductsStream(lastDoc, sortModel),
      sortModel,
    )..requestData();
  },
);

final productsByCategoryProvider =
    ChangeNotifierProvider.autoDispose.family<PagedProductsStateNotifier<DocumentSnapshot>, CategoryPlainModel>(
  (ref, category) {
    final sortModel = ref.watch(sortModelProvider.state).state;

    return PagedProductsStateNotifier(
      (lastDocument) =>
          ref.watch(productsRepositoryProvider).getProductsByCategoryStream(category, lastDocument, sortModel),
      sortModel,
    )..requestData();
  },
);

final categoryHasProductsProvider = StateProvider.autoDispose.family<bool, List<CategoryPlainModel>>(
  (ref, categories) {
    final appliedFilter = ref.watch(appliedFilterProvider(FilterType.categoryProducts).state).state;

    final providers = categories
        .map((e) => appliedFilter.isAnyFilterActive ? filteredProductsProvider(e) : productsByCategoryProvider(e))
        .toList();

    final productsStates = providers.map((provider) => ref.watch(provider)).map((e) => e.itemsState).toList();

    return productsStates.any((element) => !element.isDoneAndEmpty);
  },
);
