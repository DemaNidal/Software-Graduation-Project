const mongoose = require('mongoose');// Erase if already required

// Declare the Schema of the Mongo model
var commentSchema = new mongoose.Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref: "User",
        required:true,
    },
    text:{
        type:String,
        required:true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    }
});

const Comment = mongoose.model('Comment', commentSchema);

module.exports = Comment;