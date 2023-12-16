const User = require("../models/userModel");
const asyncHandler = require("express-async-handler");
const authMiddleware = asyncHandler(async (req, res, next) => {
    let token;
    if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
      token = req.headers.authorization.split(" ")[1]; // Use a space as the split delimiter
      try {
        if (token) {
          const decoded = jwt.verify(token, process.env.JWT_SECRET);
          const user = await User.findById(decoded.id);
          req.user = user;
          next();
          console.log(decoded);
        }
      } catch (error) {
        throw new Error("Not Authorized: Token expired or invalid, please login again.");
      }
    } else {
      throw new Error("There is no token attached to the header");
    }
  });
  
  const isAdminMiddleware = asyncHandler(async (req, res, next) => {
    const {email} = req.user;
    const adminUser= await User.findOne({email});
    if(adminUser.isAdmin == false){
        throw new Error('not admin');
    }
    else{
        next();
    }
  });
  
  module.exports = { authMiddleware, isAdminMiddleware };
  