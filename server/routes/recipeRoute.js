const express = require('express');
const {createRecipe, getallRecipes,getRecipesByCategory} = require('../controller/recipeCtrl');
const router = express.Router();

router.post('/', createRecipe);
router.get('/', getallRecipes);
router.get('/:category', getRecipesByCategory);

module.exports = router;