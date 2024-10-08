import 'package:bottleshop_admin/src/core/presentation/widgets/chips/orders/admin_user_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/orders/completed_order_chip.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/orders/order_type_chip.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderChipsRow extends StatelessWidget {
  const OrderChipsRow({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) => Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          OrderTypeChip(
            orderTypeModel: order.orderType,
          ),
          if (order.isTakenOverByAdmin)
            AdminUserChip(
              adminUser: order.preparingAdmin,
            ),
          if (order.isComplete) CompletedOrderChip(),
        ],
      );
}
