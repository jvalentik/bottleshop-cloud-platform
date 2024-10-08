import { CallableContext } from 'firebase-functions/lib/v1/providers/https';
import * as functions from 'firebase-functions';
import Stripe from 'stripe';

import { DocumentChange, getDocumentChange } from '../utils/document-snapshot-utils';
import { getEntityByRef } from '../utils/document-reference-utils';
import { tier1Region } from '../constants/other';
import { User } from '../models/user';
import { usersCollection } from '../constants/collections';
import { createStripeClient } from '..';

export const createStripeCustomer = functions
  .region(tier1Region)
  .runWith({ enforceAppCheck: false })
  .https.onCall(async (data: Stripe.CustomerCreateParams, context: CallableContext) => {
    try {
      const userUid = context.auth?.uid;
      if (userUid === undefined) {
        return { access: 'denied' };
      }

      const stripe = createStripeClient();
      const stripeCustomer = await stripe.customers.create(data);
      return { stripeCustomerId: stripeCustomer.id };
    } catch (e) {
      functions.logger.error('failed to create StripeCustomer', e);
      return e;
    }
  });

const createStripeCustomerParams = (user: User) => {
  const { uid, email, name, phone_number: phone } = user;
  const stripeCustomer = { email, name, metadata: { uid } } as Stripe.CustomerCreateParams;
  if (user.billing_address) {
    const { streetName: line1, streetNumber: line2, city, zipCode: postal_code } = user.billing_address;
    stripeCustomer.address = {
      line1,
      line2,
      city,
      postal_code,
      country: 'SK',
    } as Stripe.AddressParam;
    if (phone) {
      stripeCustomer.phone = phone;
    }
  }
  return stripeCustomer;
};

const updateStripeCustomer = async (userSnapshot: functions.Change<functions.firestore.DocumentSnapshot>) => {
  try {
    const user = await getEntityByRef<User>(userSnapshot.after.ref);
    if (!user || !user.stripe_customer_id) {
      return;
    }
    const stripe = createStripeClient();
    const params = createStripeCustomerParams(user);
    await stripe.customers.update(user.stripe_customer_id, params);
  } catch (e) {
    functions.logger.error('failed creating Stripe user: ', e);
  }
};

export const onUserWrite = functions
  .region(tier1Region)
  .firestore.document(`${usersCollection}/{userId}`)
  .onWrite(async (snap) => {
    if (getDocumentChange(snap) === DocumentChange.updated) {
      await updateStripeCustomer(snap);
    }
  });
