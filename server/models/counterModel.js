const mongoose = require('mongoose'); // Erase if already required

// Declare the Schema of the Mongo model
var counterSchema = new mongoose.Schema({
    collectionName: {
        type: String,
        required: true,
        unique: true,
      },
      counter: {
        type: Number,
        default: 1,
      },
});

//Export the model
module.exports = mongoose.model('Counter', counterSchema);