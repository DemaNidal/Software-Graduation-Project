var admin = require("firebase-admin");
var FCM = require("fcm-node");

var serviceAccount = require("../config/push-notification-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Replace 'your-server-key' with your actual FCM server key

var fcm = new FCM(serviceAccount);
exports.sendPushNotification = async (user) => {
  try {
    const userToken = user && user.token ? user.token : "fU_V_vu6T-mrg-d-1yiJ-J:APA91bH1sVCWTfODjKE6rOkRZM95zDbFaO8nK3wBbVej1rAMhbIJW6iCkhzHNB2d2Lmafi0x0Am7pnyIImdXbhR0i1I41HSO5Pg9FBU5UnH057l24ky6SDK8_YZdzNwh6igcpDVKep1T";
    console.log(userToken);
    const message = {
      notification: {
        title: "Product Update Notification",
        body: `The product  in your wishlist has been updated!`,
      },
      data: {
       "Sale":"big sale !!"
        // Add more data as needed for your notification
      },
      to: userToken,
    };

    fcm.send(message, function (err, resp) {
      if (err) {
        console.error(`Error sending notification to user ${user._id}:`, err);
      } else {
        console.log(`Notification sent to user ${user._id}`);
      }
    });
  } catch (error) {
    console.error('Error sending notification:', error);
  }
};
