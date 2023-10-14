import 'package:delivery/src/features/home/data/models/open_hours_model.dart';
import 'package:delivery/src/features/home/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/checkout/presentation/providers/providers.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/shipping_details_view.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:intl/intl.dart';

class DeliveryOptionTile extends HookConsumerWidget {
  final UserModel? user;

  const DeliveryOptionTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOrderType = ref.watch(orderTypeStateProvider);
    final currentLang = ref.watch(currentLanguageProvider);
    final openHours = ref.watch(openHoursStreamProvider.future);
    final items = <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 68),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            context.l10n.payUpfront,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      Divider(
        height: 10,
        thickness: 2,
        indent: 68,
        endIndent: 980,
        color: Theme.of(context).colorScheme.secondary,
      ),
      ...ref.watch(orderTypesProvider).maybeWhen(
            data: (orderTypes) => orderTypes.map<Widget>(
              (orderType) => RadioListTile<OrderTypeModel>(
                title: Text(orderType.getName(currentLang)!,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(orderType.getDescription(currentLang)!,
                    style: Theme.of(context).textTheme.bodySmall),
                dense: true,
                activeColor: Theme.of(context).colorScheme.secondary,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                value: orderType,
                groupValue: selectedOrderType,
                onChanged: (value) async {
                  if (value?.deliveryOption == DeliveryOption.pickUp ||
                      value?.deliveryOption == DeliveryOption.quickDeliveryBa ||
                      value?.deliveryOption == DeliveryOption.closeAreasDeliveryBa){
                    var res = await openHours;
                    showPopUp(ref, context, res);
                      }
                  ref
                      .read(orderTypeStateProvider.notifier)
                      .selectOrderType(value!);
                  final deniedReasons = ref
                      .read(orderTypeStateProvider.notifier)
                      .validate(user, value.deliveryOption);
                  onUserDenied(context, deniedReasons);
                 
                },
              ),
            ),
            orElse: () => [],
          ),
    ];
    items.insertAll(items.length - 1, <Widget>[
      Container(
        padding: const EdgeInsets.only(left: 65),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            context.l10n.payLater,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      Divider(
        height: 10,
        thickness: 2,
        indent: 65,
        endIndent: 980,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ]);

    return Card(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.only(bottom: 8),
        initiallyExpanded: true,
        leading: const Icon(
          Icons.airport_shuttle,
        ),
        title: Text(
          context.l10n.deliveryOptions,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          context.l10n.selectDeliveryOption,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: items,
      ),
    );
  }

  void showPopUp(WidgetRef ref, BuildContext context, List<OpenHourModel> openHours){
    
    OpenHourModel? closing = null;
    final currentDay =
        DateFormat('EEEE', 'en_US')
            .format(DateTime.now());
      openHours.forEach((x) {
        if (!DateUtils.dateOnly(x.dateFrom)
                .isBefore(DateUtils.dateOnly(DateTime.now())) &&
            !DateUtils.dateOnly(x.dateFrom)
                .isAfter(DateUtils.dateOnly(DateTime.now()))) 
          closing = x;
        
      });
      if (closing == null) if (currentDay == "Saturday")
        closing = openHours.firstWhere((x) => x.type == "Saturday");
      else if (currentDay == "Sunday")
        closing = openHours.firstWhere((x) => x.type == "Sunday");
      else
        closing = openHours.firstWhere((x) => x.type == "Workdays");
     bool res = ((closing!.dateTo.hour + closing!.dateTo.minute / 60.0 >= DateTime.now().hour + DateTime.now().minute / 60.0) && (closing!.dateTo.hour + closing!.dateTo.minute / 60.0 >= DateTime.now().hour + DateTime.now().minute / 60.0)) && !closing!.isClosed;
     if(!res)
     showDialog(
              context: context,
              builder: (BuildContext context) => buildPopupDialog(context),
            );  
    }
  
}

Widget buildPopupDialog(BuildContext context) {
  return AlertDialog(
    title: null,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.l10n.popUpOpenHours),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child:  Text(context.l10n.deleteAccountNegativeOption),
      ),
    ],
  );
}
