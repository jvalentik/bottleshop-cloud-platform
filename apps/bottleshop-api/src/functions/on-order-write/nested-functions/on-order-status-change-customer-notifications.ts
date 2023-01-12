import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import { createNotification, getCustomerDeviceTokens } from '../../../utils/notification-utils';
import { CustomerOrderNotification } from '../../../models/notification-models';
import { getEntityByRef } from '../../../utils/document-reference-utils';
import { getStatusStepNotificationTitle } from '../../../utils/order-utils';
import { isEmulator } from '../../../utils/functions-utils';
import { Order } from '../../../models/order';
import { OrderType } from '../../../models/order-type';
import { usersCollection } from '../../../constants/collections';

export const onOrderStatusChangeCustomerNotification = async (orderSnapshot: functions.firestore.DocumentSnapshot) => {
  const order = orderSnapshot.data() as Order;

  if (isEmulator()) {
    functions.logger.log(`Sending order status change customer notification. Order: ${JSON.stringify(order)}`);
    return;
  }

  const [deviceTokens, orderType] = await Promise.all([
    getCustomerDeviceTokens(admin.firestore().collection(usersCollection).doc(order.customer.uid)),
    getEntityByRef<OrderType>(order.order_type_ref),
  ]);

  if (orderType === undefined) {
    functions.logger.error(`Could not get OrderType entity by reference: ${order.order_type_ref}`);
    return;
  }

  const title = getStatusStepNotificationTitle(
    order.status_step_id,
    order,
    orderType.code,
    order.customer.preferred_language ?? 'sk',
  );

  if (title !== undefined) {
    const notification = createNotification<CustomerOrderNotification>({
      title,
      body: '',
      payload: {
        order_id: order.id.toString(),
        document_id: orderSnapshot.id,
      },
    });

    await admin.messaging().sendToDevice(deviceTokens, notification);
  }
};
