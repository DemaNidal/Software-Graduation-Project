const mongoose = require("mongoose"); // Erase if already required
const Comment = require("../models/commentModel");
const user = require("../models/userModel");
const Recipe = require("../models/recipesModel");

// Declare the Schema of the Mongo model

const productSchema = new mongoose.Schema({
    product_id: {
      type: Number,
      unique: true,
    },
    price: {
      type: Number,
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: true,
    },
    numberOfBuy: {
      type: Number,
      required: true,
    },
    numberOfProduct: {
      type: Number,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    isLikedBy: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'users',
    }],
    comments: [Comment.schema],
    ratings: [
      {
        star: Number,
        postedby: { type: mongoose.Schema.Types.ObjectId, ref: "users" },
      },
    ],
    totalrating: {
      type: String,
      default: 0,
    },
    sale: {
      type: Number,
      default: 0,
    },
    recipe: [{ type: mongoose.Schema.Types.ObjectId, ref: 'recipe' }]
  });
  
  productSchema.pre("save", async function (next) {
    if (!this.product_id) {
      const counter = await AutoIncrement.findOneAndUpdate(
        { collectionName: "products" },
        { $inc: { counter: 1 } },
        { upsert: true, new: true }
      );
  
      this.product_id = counter.counter;
    }
    next();
  });
//Export the model
module.exports = mongoose.model("Product", productSchema);