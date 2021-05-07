/* eslint-disable no-undef */
/* eslint-disable max-len */
const admin = require("firebase-admin");
const serviceAccount = require("./service-account.json");

// Initialize FirebaseApp
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const request = require("request-promise");

const kakaoAppId = "517182";

// Kakao API request url to retrieve user profile based on access token
const requestMeUrl = "https://kapi.kakao.com/v2/user/me?secure_resource=true";

/**
 * requestMe - Returns user profile from Kakao API
 *
 * @param  {String} kakaoAccessToken Access token retrieved by Kakao Login API
 * @return {Promise<Response>}      User profile response in a promise
 */
function requestMe(kakaoAccessToken) {
  console.log("4. Requesting user profile from Kakao API server.");
  console.log("5. kakao App Id is " + kakaoAppId);
  return request({
    method: "GET",
    headers: {Authorization: "Bearer " + kakaoAccessToken},
    url: requestMeUrl,
  });
}

/**
 * getUser - fetch firebase user with kakao UID first, then with email if
 * no user found. If email is not verified, throw an error so that
 * the user can re-authenticate.
 *
 * @param {String} kakaoUserId    user id per app
 * @param {String} email          user's email address
 * @param {Boolean} emailVerified whether this email is verified or not
 * @return {Promise<admin.auth.UserRecord>}
 */
function getUser(kakaoUserId, email, emailVerified) {
  console.log("9. getUser function triggered with kakaoUserId: " + kakaoUserId);
  return admin
      .auth()
      .getUser(kakaoUserId)
      .catch((error) => {
        if (error.code != "auth/user-not-found") {
          throw error;
        }
        if (!email) {
          throw error; // cannot find existing accounts since there is no email.
        }
        console.log(`10. fetching a firebase user with email ${email}`);
        return admin
            .auth()
            .getUserByEmail(email)
            .then((userRecord) => {
              if (!emailVerified) {
                throw new Error("This user should authenticate first with other providers");
              }
              throw new Error("The email address is already in use by another account.");
            });
      });
}

/**
 * createUser - Create Firebase user with the give email
 *
 * @param  {String} userId        user id per app
 * @param  {String} email         user's email address
 * @param  {Boolean} isEmailVerified whether this email is verified or not
 * @param  {String} displayName   user
 * @param  {String} photoURL      profile photo url
 * @return {Prommise<UserRecord>} Firebase user record in a promise
 */
function createUser(userId, email, isEmailVerified, displayName, photoURL) {
  console.log("8. create user function triggered");
  return getUser(userId, email, isEmailVerified).catch((error) => {
    if (error.code == "auth/user-not-found") {
      const params = {
        uid: userId,
        displayName: displayName,
      };
      if (email) {
        params["email"] = email;
      }
      if (photoURL) {
        params["photoURL"] = photoURL;
      }
      console.log(`11. creating a firebase user with email ${email}`);
      return admin.auth().createUser(params);
    }
    console.log("error occured "+ error);
    throw error;
  });
}

/**
 * createFirebaseToken - returns Firebase token using Firebase Admin SDK
 *
 * @param  {String} kakaoAccessToken access token from Kakao Login API
 * @return {Promise<String>}                  Firebase token in a promise
 */
exports.createFirebaseToken = function(kakaoAccessToken) {
  console.log("3. create Firebase token function triggered");
  return requestMe(kakaoAccessToken).then((response) => {
    const body = JSON.parse(response);
    console.log("6. body is " + body);
    const userId = `kakao:${body.id}`;
    console.log("7. uid is " + userId);
    if (!userId) {
      // return res.status(404)
      //     .send({message: "There was no user with the given access token."});
      throw new Error("There was no user with the given access token.");
    }
    let nickname = null;
    let profileImage = null;
    let email = null;
    let isEmailVerified = null;
    if (body.properties) {
      nickname = body.properties.nickname;
      profileImage = body.properties.profile_image;
    }
    if (body.kakao_account) {
      email = body.kakao_account.email;
      isEmailVerified = body.kakao_account.is_email_verified;
    }
    return createUser(userId, email, isEmailVerified, nickname, profileImage);
  }).then((userRecord) => {
    const userId = userRecord.uid;
    console.log(`12. creating a custom firebase token based on uid ${userId}`);
    return admin.auth().createCustomToken(userId, {provider: "kakaocorp.com"});
  });
};

/**
 * linkUserWithKakao - Link current user record with kakao UID
 * if not linked yet.
 *
 * @param {String} kakaoUserId
 * @param {admin.auth.UserRecord} userRecord
 * @return {Promise<UserRecord>}
 */
exports.linkUserWithKakao = function(kakaoUserId, userRecord) {
  if (userRecord.customClaims && userRecord.customClaims["kakaoUID"] == kakaoUserId) {
    console.log(`currently linked with kakao UID ${kakaoUserId}...`);
    return Promise.resolve(userRecord);
  }
  console.log(`linking user with kakao UID ${kakaoUserId}...`);
  return admin
      .auth()
      .setCustomUserClaims(userRecord.uid, {kakaoUID: kakaoUserId, provider: "kakaocorp.com"})
      .then(() => userRecord);
};
