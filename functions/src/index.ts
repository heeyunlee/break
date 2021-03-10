import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

const app = admin.initializeApp();
const firestore = app.firestore();

 export const helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", {structuredData: true});
    response.send("Hello World, from Firebase!");
 });

 export const getFavorites_v0 = functions.https.onRequest(async (request, response) => {
    const userId = request.query.id;
    if (userId) {
       response.send('I am going to get favorites for user ${userId}');
       const snapshot = await firestore.collection('workouts').limit(1).get();
       snapshot.forEach(docSnapshot => (console.log(docSnapshot.data())));
       return;
    }
    response.send('No userId');
 });

 exports.recursiveDelete = functions
  .runWith({
    timeoutSeconds: 540,
    memory: '2GB'
  })
  .https.onCall(async (data, context) => {
    // Only allow admin users to execute this function.
    if (!(context.auth && context.auth.token && context.auth.token.admin)) {
      throw new functions.https.HttpsError(
        'permission-denied',
        'Must be an administrative user to initiate delete.'
      );
    }

    const path = data.path;
    console.log(
      `User ${context.auth.uid} has requested to delete path ${path}`
    );

    // Run a recursive delete on the given document or collection path.
    // The 'token' must be set in the functions config, and can be generated
    // at the command line by running 'firebase login:ci'.
    await firebase_tools.firestore
      .delete(path, {
        project: process.env.GCLOUD_PROJECT,
        recursive: true,
        yes: true,
        token: functions.config().fb.token
      });

    return {
      path: path 
    };
  });