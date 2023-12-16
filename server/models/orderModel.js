const mongoose = require('mongoose'); // Erase if already required

// Declare the Schema of the Mongo model
var orderSchema = new mongoose.Schema(
    {
    products:[
        {
            product:{
                type:  mongoose.Schema.Types.ObjectId,
                ref: "Product",
            },
            count: Number,
            
        },
    ],
    paymentIntent: {},
    orderStatus: {
        type: String,
        defult: "Not Processed",
        enum: [
            "Not Processed",
            "Processing",
            "Dispatched",
            "Cancelled",
            "Delivered",
        ],
    },
    orderby: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
    },
    arrivalDate: {
        type: Date,  // Assuming arrival date is a date type
    }
    },
    {
        timestamps: true,
    }

);

//Export the model
module.exports = mongoose.model('Order', orderSchema);