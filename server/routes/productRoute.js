const express = require("express");
const { 
    createProduct, 
    getaProduct, 
    getAllProduct,
    updateProduct, 
    deleteProduct,
    addToWishlist,
    getBestSellers, 
    searchProduct,
    foodProduct,
    spiceProduct,
    coffeeProduct,
    rating,
    updateAllProducts
} = require("../controller/productCtrl");
const router = express.Router();

router.post("/", createProduct);
router.get("/:id", getaProduct);
router.put("/:id", updateProduct);
router.put("/", updateAllProducts);
router.delete("/:id", deleteProduct);
router.post("/best" , getBestSellers );
router.put("/wishlist/:id",  addToWishlist);
router.post("/search",  searchProduct);
router.post("/food",  foodProduct);
router.post("/spice",  spiceProduct);
router.post("/coffee",  coffeeProduct);
router.get('/',getAllProduct );
router.delete("/wishlist/:id",  addToWishlist);
router.put("/rating/:id",  rating);


module.exports = router;