const express = require('express');
const { createUser, loginUserCtrl ,userCart, getallUser, 
    getaUser, updateUser, getUserCart, emptyCart, 
    createOrder, getOrders, updateOrderStatus, 
    getWishlist,removeItemFromCart,signUp,
    sendOtp,verify,createPass, updateCartItem,updateArrivalDate,generateRecommendations} = require('../controller/userCtrl');
const {authMiddleware,isAdminMiddleware }= require("../middlewares/authMiddleware");
const router = express.Router();
router.post("/register", createUser);
router.post("/signup", signUp);
router.post("/login", loginUserCtrl);
router.put("/order/:id",updateOrderStatus);
router.post("/all-users", getallUser);
router.get("/:id" , getaUser);
router.post("/cart/:id", userCart);
router.put("/cart/:id/:productId", updateCartItem);
router.post("/cart/remove/:id/:itemID", removeItemFromCart);
router.post("/cart/cash-order/:id/:discount", createOrder);
router.get("/cart/get-orders/:id",getOrders);
router.get("/cart/:id", getUserCart);
router.delete('/empty-cart/:id',emptyCart);
router.put("/edit-user/:id/:fullName/:phoneNumber/:password", updateUser);
router.get("/wishlist/:id", getWishlist);
router.put('/update-arrival-date/:orderId', updateArrivalDate);

router.post("/otpLogin" , sendOtp);
router.post("/recommendationRecipes/:id" , generateRecommendations);
router.post("/verifyOTP", verify);
router.put("/newPass", createPass);

module.exports = router;