// pushNotificationRoute.js
const express = require("express");
const router = express.Router();
const { sendPushNotification } = require("../controller/pushNotificationController");
router.post("/send-notification", sendPushNotification);
module.exports = router;
