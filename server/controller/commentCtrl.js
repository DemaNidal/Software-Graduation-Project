const asyncHandler = require("express-async-handler");
const User = require("../models/userModel");
const Product = require("../models/productModel");
const Comment = require("../models/commentModel");

const showComment = asyncHandler(async (req, res) => {
  try {
    const productId = req.params.id;
    const product = await Product.findById(productId).populate({
      path: 'comments',
      populate: { path: 'user', select: 'fullName' } // Populate the 'user' field and select 'fullName'
    });

    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    // Extract comment texts and user names
    const commentsWithUserNames = product.comments.map(comment => ({
      text: comment.text,
      userName: comment.user ? comment.user.fullName : comment.user
    }));

    res.json({ comments: commentsWithUserNames });
  } catch (error) {
    console.error("Error:", error); // Log the specific error for debugging
    res.status(500).json({ msg: "Internal Server Error" });
  }
});

// Rest of your code...



// Rest of your code...


  const addComment=  asyncHandler( async (req, res) => {
    try {
      const { userName, userEmail, text, parentCommentId } = req.body;
      const productId = req.params.id;
  console.log(productId);
      const product = await Product.findById(productId);
      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }
  
      // Find user by name or email
      const user = await User.findOne({
        $or: [{ fullName: userName }, { email: userEmail }],
      });
  
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }
  
      const parentComment = parentCommentId
        ? await Comment.findById(parentCommentId)
        : null;
  
      const comment = new Comment({
        user: user._id, // Assign user ID to the comment
        text,
      });
  
      if (parentComment) {
        parentComment.replies.push(comment);
        await parentComment.save(); // Save the parent comment with the new reply
      } else {
        product.comments.push(comment);
        await product.save(); // Save the product with the new comment
      }
  
      // Save the comment itself
      await comment.save();
  
      return res.status(201).json(comment);
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
  });
  





module.exports = { 
    showComment,
    addComment
};