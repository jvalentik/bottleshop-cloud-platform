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
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/services/wallets_availability_service.dart';
import 'package:delivery/src/features/checkout/data/models/payment_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:overlay_support/overlay_support.dart';

import '../providers/providers.dart';

class NativePayments extends HookConsumerWidget with UiLoggy {
  final PaymentData paymentData;
  final double value;
  final void Function(String checkoutDoneMsg) onCheckoutDone;

  const NativePayments({
    Key? key,
    required this.paymentData,
    required this.value,
    required this.onCheckoutDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSupported = ref.watch(
        walletsAvailableProvider.select((value) => value.applePayAvailable));
    return isSupported
        ? Column(
            children: [
              Text(
                context.l10n.orCheckoutWith,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 208,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: !isDarkMode ? Colors.black : Colors.white),
                  child: Image.asset(
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? !isDarkMode
                            ? kApplePayBtnDark
                            : kApplePayBtn
                        : !isDarkMode
                            ? kGooglePayBtnDark
                            : kGooglePayBtn,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () async {
                    try {
                      await ref
                          .read(checkoutStateProvider)
                          .payByNativePay(paymentData)
                          .then(
                            (value) => onCheckoutDone(
                              defaultTargetPlatform == TargetPlatform.android
                                  ? context.l10n.successful_payment_gpay
                                  : context.l10n.successful_payment,
                            ),
                          );
                    } on PlatformException catch (err, stack) {
                      if (err.code != 'cancelled' ||
                          err.code != 'purchaseCancelled') {
                        rethrow;
                      } else {
                        loggy.error('Failed to pay by native', err, stack);
                        showSimpleNotification(
                          Text(context.l10n.errorGeneric),
                          position: NotificationPosition.bottom,
                          context: context,
                        );
                      }
                    } catch (err, stack) {
                      loggy.error('Failed to pay by native', err, stack);
                      showSimpleNotification(
                        Text(context.l10n.errorGeneric),
                        position: NotificationPosition.bottom,
                        context: context,
                      );
                    }
                  },
                ),
              ),
            ],
          )
        : Container();
  }
}
