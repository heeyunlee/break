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
