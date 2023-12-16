const mongoose = require('mongoose'); // Erase if already required
const Product = require("../models/productModel");
// Declare the Schema of the Mongo model
const recipeSchema = new mongoose.Schema({
    title:{
        type:String,
        required:true,
        unique:true,
    },
    time:{
        type:String,
        required:true,
    },
    calo:{
        type:String,
        required:true,
    },
    prot:{
        type:String,
        required:true,
    },
    totalRating: {
        type: Number,

    },
    categories: {
        type: [String],
        enum: ['drinks', 'sweets', 'breakfast', 'vegan', 'salads'],
    },
    
    image: {
        type: String,
        required: true,
    },
    ingredients: {
        type: [String],
    },
    preparation: {
        type: [String],
    },
    product: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }]
});

//Export the model
const Recipe = mongoose.model('Recipe', recipeSchema);
module.exports = Recipe;