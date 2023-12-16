const mongoose = require('mongoose'); // Erase if already required

// Declare the Schema of the Mongo model
const historyNotificationsSchema = new mongoose.Schema({
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User', // Assuming you have a User model
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    body: {
      type: String,
      required: true,
    },
    data: {
      type: mongoose.Schema.Types.Mixed,
    },
    isRead: {
      type: Boolean,
      default: false, // Default value is false for unread
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  });
//Export the model
module.exports = mongoose.model('historyNotifications', historyNotificationsSchema);