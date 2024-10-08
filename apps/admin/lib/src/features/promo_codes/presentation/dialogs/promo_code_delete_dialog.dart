import 'package:bottleshop_admin/src/config/app_strings.dart';
import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/action_result.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/processing_alert_dialog.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/services/services.dart';
import 'package:flutter/material.dart';

class PromoCodeDeleteResult {
  PromoCodeDeleteResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class PromoCodeDeleteDialog extends ProcessingAlertDialog {
  PromoCodeDeleteDialog({
    Key? key,
    required PromoCodeModel promoCode,
  }) : super(
          key: key,
          actionButtonColor: Colors.red,
          negativeButtonOptionBuilder: (_) => Text('Nie',
              style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey)),
          positiveButtonOptionBuilder: (_) => Text(
            'Áno',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
          ),
          onPositiveOption: (context) => promoCodesDbService
              .removeItem(promoCode.uid)
              .then(
                (_) => Navigator.pop(
                  context,
                  PromoCodeDeleteResult(
                    ActionResult.success,
                    AppStrings.promoCodeDeletionSuccessMsg,
                  ),
                ),
              )
              .catchError(
                (err) => Navigator.pop(
                  context,
                  PromoCodeDeleteResult(
                    ActionResult.failed,
                    AppStrings.unknownErrorMsg,
                  ),
                ),
              ),
          onNegativeOption: Navigator.pop,
        );

  @override
  Widget content(BuildContext context) => Text(
        'Naozaj chcete odstrániť tento promo kód?',
        style: AppTheme.alertDialogContentTextStyle,
      );
}
