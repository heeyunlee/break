const functions = require("firebase-functions");
const kakao = require("./kakao");

exports.verifyKakaoToken = functions.https.onCall(async (request) => {
  console.log("1. verify token function trigggered");
  const token = request.token;
  if (!token) {
    return {error: "1.1 There is no token provided."};
  }

  console.log(`2. Verifying Kakao token: ${token}`);

  return kakao
      .createFirebaseToken(token)
      .then((firebaseToken) => {
        console.log(`13. Returning firebase token to user: ${firebaseToken}`);
        return {token: firebaseToken};
      })
      .catch((e) => {
        return {error: e.message};
      });
});
