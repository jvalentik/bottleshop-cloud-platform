import 'dart:async';

import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_view_model.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/repositories/flash_sale_products_repository.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/repositories/flash_sales_repository.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/presentation/view_models/flash_sale_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final flashSaleProductsRepository =
    Provider((ref) => FlashSaleProductsRepository());

final flashSalesRepository = Provider((ref) => FlashSalesRepository(ref));

final flashSaleViewModelProvider =
    ChangeNotifierProvider.autoDispose<FlashSaleViewModel>(
  (ref) {
    return ref.watch(flashSaleProvider).maybeWhen(
          data: (flashSale) => FlashSaleViewModel(flashSale),
          orElse: () => FlashSaleViewModel(FlashSaleModel.empty()),
        );
  },
);

// TODO: This is being updated every time FlashSaleModel changes - listen only to specific changes.
final _dateTimeProvider =
    StateProvider.autoDispose.family<DateTime, FlashSaleModel>(
  (res, flashSale) =>
      res.watch(flashSaleViewModelProvider).currentFlashSale.flashSaleUntil,
);

final timeDifferenceProvider = StateNotifierProvider.autoDispose
    .family<StateController<Duration>, Duration, FlashSaleModel>(
  (res, flashSale) {
    final notifier = StateController<Duration>(Duration(seconds: 1));
    final timer = Timer.periodic(
      Duration(seconds: 1),
      (_) {
        final diff = res
            .read(_dateTimeProvider(flashSale))
            .state
            .difference(DateTime.now());

        // Do not update the difference every second when negative.
        if (!diff.isNegative || !(notifier.state.isNegative)) {
          notifier.state = res
              .read(_dateTimeProvider(flashSale))
              .state
              .difference(DateTime.now());
        }
      },
    );

    res.onDispose(
      timer.cancel,
    );

    return notifier;
  },
);

final flashSaleProductsProvider =
    ChangeNotifierProvider.autoDispose.family<ProductStateViewModel, String>(
  (ref, flashSaleUid) => ProductStateViewModel(
    () => ref
        .read(flashSaleProductsRepository)
        .getFlashSaleProductsStream(flashSaleUid),
  )..requestData(),
);

final isFlashSaleLoadedProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(flashSaleProvider).when(
        data: (_) => true,
        loading: () => false,
        error: (err, stacktrace) {
          debugPrint(err.toString());
          return false;
        },
      ),
);

final flashSaleProvider = StreamProvider.autoDispose<FlashSaleModel>(
    (ref) => ref.watch(flashSalesRepository).getFlashSaleStream());
