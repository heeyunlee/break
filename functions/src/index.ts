import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';

admin.initializeApp();

const app = express();
app.get('/timestamp', (request, response) => {
   response.send('');
})

// const db = admin.firestore();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

 export const helloWorld = functions.https.onRequest(app);

 export const getSavedRoutine_v0 = functions.https.onRequest(async (request, response) => {})

//  export const updateUsername = functions.firestore.document('users/{docId}').onUpdate(async (change, context) => {
//     const document = change.after.data();
//     const uid = document.userId;

//     const documents = await db.collection('routine_histories').where('userId','==',uid).get();
//     documents.forEach()
    
//  })