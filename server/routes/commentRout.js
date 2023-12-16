const express = require("express");
const { showComment,addComment } = require("../controller/commentCtrl");
const router = express.Router();

router.get("/:id/comments", showComment);
router.post("/:id/comments", addComment);
module.exports = router;
