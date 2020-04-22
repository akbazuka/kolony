import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const stripe = require('stripe')(functions.config().stripe.secret_test_key)

// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.firestore.document('users/{userId}').onCreate(async (snap, context) => {
  const data = snap.data();
  const email = data['email'];

  console.log(data)
  const customer = await stripe.customers.create({ email: email });
  return admin.firestore().collection('users').doc(data['id']).update({ stripeId: customer.id });
});

// Generate an ephemeral key (temporary) for each payment to be processed
exports.createEphemeralKey = functions.https.onCall(async (data, context) => {

    const customerId = data.customer_id;
    const stripeVersion = data.apiVersion;

    return stripe.ephemeralKeys.create(
        { customer: customerId },
        { apiVersion: stripeVersion }
    ).then((key) => {
        return key
    }).catch((err) => {
        console.log(err)
        throw new functions.https.HttpsError('internal', ' Unable to create ephemeral key: ' + err);
    });
});
  
/*
This is the method used for credit cards and uses the new Payment Methods API.
Creates a http charge request tp process payment with Stripe
*/
export const createCharge = functions.https.onCall(async (data, context) => {

    const customerId = data.customer_id;
    const paymentMethodId = data.payment_method_id;
    const totalAmount = data.total_amount;
    const idempotency = data.idempotency;

    return stripe.paymentIntents.create({
        payment_method: paymentMethodId,
        customer: customerId,
        amount: totalAmount,
        currency: 'usd',
        confirm: true,
        payment_method_types: ['card']
    }, {
            idempotency_key: idempotency
        }).then(intent => {
            console.log('Charge Success: ', intent)
            return
        }).catch(err => {
            console.log(err);
            throw new functions.https.HttpsError('internal', ' Unable to create charge: ' + err);
        });
});