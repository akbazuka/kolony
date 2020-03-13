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

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
//  exports.helloWorld = functions.https.onRequest((request, response) => {
//      console.log("This is the console message.")
//   response.send("Hello from Firebase!");
//  });
