const Recipe = require("../models/recipesModel");
const Product = require("../models/productModel");
const asyncHandler = require("express-async-handler");
const slugify = require("slugify");

const createRecipe = asyncHandler(async (req, res) => {
    try {
        // Sanitize and validate input fields as needed

        if (req.body.title) {
            req.body.slug = slugify(req.body.title);
        }

        // Assuming Product and Recipe are your Mongoose models
        const productIds = req.body.product;

        // Fetch the corresponding products
        const products = await Product.find({ _id: { $in: productIds } });

        if (products.length !== productIds.length) {
            // Not all products were found, handle error
            return res.status(404).json({
                success: false,
                error: 'One or more products not found',
            });
        }

        // Update the req.body to include the product IDs
        req.body.product = products.map(product => product._id);

        // Create the recipe with the updated req.body
        const newRecipe = await Recipe.create(req.body);

        // Update the recipe array in associated products
        for (const product of products) {
            // Add the recipe ID to the product's recipe array
            product.recipe.push(newRecipe._id);

            // Only update the recipe array in the product, leave other fields unchanged
            await Product.updateOne({ _id: product._id }, { $set: { recipe: product.recipe } });
        }

        res.status(201).json({
            success: true,
            data: newRecipe,
        });
    } catch (error) {
        console.error('Error creating recipe:', error);
        res.status(500).json({
            success: false,
            error: 'Internal Server Error',
        });
    }
});

const getallRecipes = asyncHandler(async (req, res) => {
    try {
        // Fetch all recipes from the database
        const recipes = await Recipe.find();

        res.status(200).json({
            success: true,
            data: recipes,
        });
    } catch (error) {
        console.error('Error fetching recipes:', error);
        res.status(500).json({
            success: false,
            error: 'Internal Server Error',
        });
    }
});

const getRecipesByCategory = asyncHandler(async (req, res) => {
    try {
        const { category } = req.params;

        // Check if the category parameter is provided
        if (!category) {
            return res.status(400).json({
                success: false,
                error: 'Category parameter is required',
            });
        }

        // Fetch recipes based on the provided category
        const recipes = await Recipe.find({ categories: category });

        res.status(200).json({
            success: true,
            data: recipes,
        });
    } catch (error) {
        console.error('Error fetching recipes by category:', error);
        res.status(500).json({
            success: false,
            error: 'Internal Server Error',
        });
    }
});

module.exports = { 
    createRecipe , 
    getallRecipes,
    getRecipesByCategory
};