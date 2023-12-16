const express = require("express");
const { createCoupon,getAllCoupons,updateCoupon,deleteCoupon,getCoupon } = require("../controller/couponCtrl");
const router = express.Router();

router.post("/",createCoupon);
router.get("/",  getAllCoupons);
router.put("/:id",  updateCoupon);
router.delete("/:id",  deleteCoupon);
router.get("/:name", getCoupon);

module.exports = router;