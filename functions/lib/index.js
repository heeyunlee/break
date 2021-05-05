const functions = require("firebase-functions");
const kakao = require("./kakao");

const admin = require("firebase-admin");
admin.initializeApp();

exports.verifyKakaoToken = functions.https.onCall(async (request) => {
  const token = request.token;
  if (!token) {
    return {error: "There is no token provided."};
  }

  console.log(`Verifying Kakao token: ${token}`);

  return kakao
      .createFirebaseToken(token)
      .then((firebaseToken) => {
        console.log(`Returning firebase token to user: ${firebaseToken}`);
        return {token: firebaseToken};
      })
      .catch((e) => {
        return {error: e.message};
      });
});
