const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

//firebase functions:config:set stripe.secret_test_key="stripe_secret_key" (in Terminal to create an environment configuration variable on local machine to more securely store stripe secret key)
//firebase functions:config:get (in Terminal to see Environment Config variables)
const stripe = require("stripe")(functions.config().stripe.secret_test_key);

/*************************Cloud functions**************************/

//Create new stripe customer when user registers on our app
exports.createStripeCustomer = functions.firestore.document('users/{userId}').onCreate(async (snap, context) => {
    const data = snap.data();
    const email = data.email;

    const customer = await stripe.customers.create({ email: email })
    return admin.firestore().collection('users').doc(data.id).update({ stripeId : customer.id})
});

//Make charge request sent to Stripe
exports.createCharge = functions.https.onCall(async (data, context) => {

    const customerId = data.customerId;
    const totalAmount = data.total;
    const idempotency = data.idempotency;
    const uid = context.auth.uid

    if (uid === null) {
        console.log('Illegal access attempt due to unauthenticated user');
        throw new functions.https.HttpsError('permission-denied', 'Illegal access attempt.')
    }
    //Pass to stripe
    return stripe.charges.create({
        amount: totalAmount,
        currency: 'usd',
        customer: customerId
    }, {
        idempotency_key: idempotency
    }).then( _ => {
        //Success case, do nothing and return to client app
        return
    }).catch( err => {
        //Show error in console and present to user that payment did not go through
        console.log(err);
        throw new functions.https.HttpsError('internal', 'Unable to create charge')
    });
})

//Firebase callable function
exports.createEphemeralKey = functions.https.onCall(async (data, context) => { //data is JSON object that is passed in the request from client app
    //Callables are automatically serialized
    const customerId = data.customer_id;
    const stripeVersion = data.apiVersion;
    const uid = context.auth.uid; //UID from context

    //If user is unauthenticated in Firebase (uid is not of a registered user)
    if(uid === null){
        console.log("Illegal access attempt due to unauthenticated user");
        throw new functions.https.HttpsError("permission-denied","Illegal access attempt")
    }

    //If user has an account with Kolony
    return stripe.ephemeralKeys.create( //From Stripe documentation
        {customer: customerId},
        {apiVersion: stripeVersion}
    ).then((key) => { //If successful, we get back key and return to client app
        return key
    }).catch((err) => {
        console.log(err)
        throw new functions.https.HttpsError("internal","Unable to create ephemeral key")
    })
})

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
//  exports.helloWorld = functions.https.onRequest((request, response) => {
//      console.log("This is the console message.")
//   response.send("Hello from Firebase!");
//  });
