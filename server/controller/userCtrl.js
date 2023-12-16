const { generateToken } = require("../config/jwtToken");
const Product  = require("../models/productModel");
const Recipe = require("../models/recipesModel");
const { body, validationResult } = require("express-validator");
const bcrypt = require('bcrypt');
const Cart  = require("../models/cartModel");
const User = require("../models/userModel");
const Order= require("../models/orderModel");
const Counter =require("../models/counterModel");
const  uniqid = require('uniqid'); 
const asyncHandler = require("express-async-handler");
const validateMongoObId = require("../utils/validateMongodbid");
const jwt = require('jsonwebtoken');

const otpGenerator = require("otp-generator");//new
const crypto = require("crypto");//new
const exp = require("constants");
const key = "otp-secret-key"; //new

const nodemailer = require("nodemailer");
const { error } = require("console");

const createUser = asyncHandler(  async (req, res) => {
    const email = req.body.email;
    const findUser = await User.findOne({email:email});
    if (!findUser) {
        //create a new User
          const newUser = await User.create(req.body);
         res.json(newUser);
    }
    else {
        //user Already Exist
        throw new Error('User Already Exist');
    }
});

const signUp = asyncHandler(async (req, res) => {
  const { email, fullName, password, livePlace, phoneNumber, dateOfBirth } = req.body;


  try {
    // Validation checks
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    // Find and update the counter
    let counter = await Counter.findOneAndUpdate(
      { collectionName: "users" },
      { $inc: { counter: 1 } },
      { upsert: true, new: true }
    );

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new User instance and save it to the database
    const newUser = new User({
      user_id: counter.counter,
      email,
      fullName,
      password: hashedPassword,
      livePlace,
      phoneNumber,
      dateOfBirth,
    });

    await newUser.save();

    res.json(newUser);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ msg: "Internal Server Error" });
  }
});

module.exports = signUp; // Export the signUp function for use in your application


// const loginUserCtrl = asyncHandler(async (req,res) =>{
//     const {email,password} = req.body;
//    // chack if user exists or not
//    const findUser = await User.findOne({email});
//    if(findUser && await findUser.isPasswordMatched(password)){
//     res.json({
//         _id: findUser?._id, 
//         email: findUser?.email,
//         fullName: findUser?.fullName,
//         mobile: findUser.phoneNumber,
//         token: generateToken(findUser?._id),
//    });
//    }else {
//     throw new Error("Invalid Credentials");
//    }
// });

const loginUserCtrl= asyncHandler( async (req, res) => {
  const { identifier, password } = req.body;

  try {
    // Find the user by email or name
    const user = await User.findOne({
      $or: [
        { email: identifier },
        { fullName: identifier }
      ]
    });

    // If the user is not found, respond with authentication failed
    if (!user) {
      return res.status(401).json({ success: false, error: 'Authentication failed' });
    }

    // Compare the provided password with the hashed password stored in the database
    const passwordMatch = await bcrypt.compare(password, user.password);

    if (passwordMatch) {
      // Passwords match, generate JWT token
      const token = jwt.sign(
        { _id: user._id, email: user.email, isAdmin: user.isAdmin },
        'your-secret-key', // Replace with your actual secret key
        { expiresIn: '1h' } // Token expires in 1 hour
      );

      res.json({ success: true, message: 'Authentication successful', token ,_id: user._id});
    } else {
      // Passwords do not match, respond with authentication failed
      res.status(401).json({ success: false, error: 'Authentication failed' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
});

const userCart = asyncHandler(async (req, res) => {
  const { cart } = req.body;
  const { id } = req.params;

  try {
    validateMongoObId(id);

    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Check if user already has a cart
    let existingCart = await Cart.findOne({ orderby: user._id });

    let cartTotal = 0;
    let productsToUpdate = [];

    for (const item of cart) {
      const product = await Product.findById(item._id).select("price").exec();
      if (product) {
        const newItem = {
          product: item._id,
          count: item.count, // Set the count directly to the new count from the request
          color: item.color,
          price: product.price,
        };

        cartTotal += newItem.price * newItem.count;

        const existingProductIndex = existingCart
          ? existingCart.products.findIndex(p => p.product.toString() === item._id)
          : -1;

        if (existingProductIndex !== -1) {
          // Product already exists in cart, update it with the new count
          existingCart.products[existingProductIndex] = newItem;
        } else {
          // Product is not in the cart, add it with the updated count
          productsToUpdate.push(newItem);
        }
      }
    }

    if (existingCart) {
      // Update the existing cart's products with new items
      existingCart.products = [...existingCart.products, ...productsToUpdate];
      existingCart.cartTotal += cartTotal;
      await existingCart.save();
      res.json(existingCart);
    } else {
      // Create a new cart if it doesn't exist
      const newCart = await Cart.create({
        products: productsToUpdate,
        cartTotal,
        orderby: user._id,
      });
      res.json(newCart);
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const updateCartItem = asyncHandler(async (req, res) => {
  const { id, productId } = req.params;
  const { count } = req.body;

  try {
    validateMongoObId(id);
    validateMongoObId(productId);

    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    let existingCart = await Cart.findOne({ orderby: user._id });
    if (!existingCart) {
      return res.status(404).json({ error: "Cart not found" });
    }

    const existingProductIndex = existingCart.products.findIndex(
      (p) => p.product.toString() === productId
    );

    if (existingProductIndex !== -1) {
      // Product found in the cart, update the count
      existingCart.products[existingProductIndex].count = count;
      existingCart.cartTotal = calculateCartTotal(existingCart.products);
      await existingCart.save();
      res.json(existingCart);
    } else {
      return res.status(404).json({ error: "Product not found in the cart" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Helper function to calculate the total price of the cart
const calculateCartTotal = (products) => {
  return products.reduce((total, product) => {
    return total + product.price * product.count;
  }, 0);
};






const getWishlist = asyncHandler(async (req, res) => {
    const { id } = req.params;
    try {
      const findUser = await User.findById(id).populate("wishlist");
      res.json(findUser);
    } catch (error) {
      throw new Error(error);
    }
  });

  
const getUserCart = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoObId(id);
    try {
        const user = await User.findById(id);
      const cart = await Cart.findOne({ orderby: user._id }).populate(
        "products.product"
      );
      res.json(cart);
    } catch (error) {
      throw new Error(error);
    }
});
    const emptyCart = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoObId(id);
    try {
        const user = await User.findById(id);
      console.log(user);
       const cart = await Cart.findOneAndRemove({ orderby: user._id });
       res.json(cart);
    } catch (error) {
      throw new Error(error);
    }
  });
  const removeItemFromCart = asyncHandler(async (req, res) => {
    const { itemID } = req.params;
    const { id } = req.params; // Assuming the user ID is available in the request
  
    try {
      validateMongoObId(id); // Validate the user ID
      
      const user = await User.findById(id);
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      const existingCart = await Cart.findOne({ orderby: user._id });
  
      if (!existingCart) {
        return res.status(404).json({ error: 'Cart not found' });
      }
  
      const indexToRemove = existingCart.products.findIndex(
        (product) => product.product.toString() === itemID
      );
      console.log('Item ID to be removed:', itemID);

      // Then proceed with your database query
      
      if (indexToRemove === -1) {
        return res.status(404).json({ error: 'Item not found in the cart' });
      }
  
      // Remove the item from the cart
      const removedItem = existingCart.products.splice(indexToRemove, 1);
  
      // Update the cart total
      existingCart.cartTotal -= removedItem[0].price * removedItem[0].count;
  
      await existingCart.save();
  
      res.json(existingCart);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
  
  
  
  const createOrder = asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { discount } = req.params;
    validateMongoObId(id);

    try {
        const user = await User.findById(id);

        // Find the user's cart
        let userCart = await Cart.findOne({ orderby: user._id });

        if (!userCart) {
            return res.status(404).json({ message: "User's cart not found" });
        }

        let finalAmount = userCart.cartTotal;
        let appliedDiscount = discount || 0; // Use the passed discount or default to 0
        appliedDiscount = (100 - appliedDiscount) / 100;

        // Log discount information
        console.log(`Discount: ${discount}`);
        console.log(`Applied Discount: ${appliedDiscount}`);
        console.log(`Final Amount before applying discount: ${finalAmount}`);

        finalAmount = finalAmount * appliedDiscount;
        console.log(`Final Amount after applying discount: ${finalAmount}`);

        // Extract relevant information from each product in the cart
        const productsInfo = userCart.products.map(item => ({
            id: item.product._id,
            image: item.product.image,
            count: item.count,
            price: item.product.price,
            title: item.product.title,
            type: item.product.type,
        }));

        // Create the order with the desired response format
        let newOrder = await new Order({
            products: productsInfo,
            paymentIntent: {
                id: uniqid(),
                amount: finalAmount,
                status: "Not Processed",
                created: Date.now(),
                currency: "ils",
            },
            discount: discount, // Store the discount in the order
            orderby: user._id,
            orderStatus: "Not Processed",
        }).save();

        // Update product quantities and sold counts
        let update = userCart.products.map((item) => ({
            updateOne: {
                filter: { _id: item.product._id },
                update: {
                    $inc: {
                        numberOfProduct: -item.count,
                        numberOfBuy: +item.count,
                    },
                },
            },
        }));

        await Product.bulkWrite(update, {});

        // Empty the user's cart
        try {
            const cart = await Cart.findOneAndRemove({ orderby: user._id });
            // Do any additional logging for debugging purposes if needed
        } catch (error) {
            throw new Error(error);
        }

        // Send the desired response format
        res.json({
            message: "Order created successfully",
            order: {
                products: productsInfo,
                orderedBy: user.username,
                orderDate: newOrder.paymentIntent.created,
                total: finalAmount,
                status: "Not Processed",
            },
        });
    } catch (error) {
        throw new Error(error);
    }
});

const updateArrivalDate = asyncHandler(async (req, res) => {
  const { orderId } = req.params;

  try {
      // Validate orderId
      validateMongoObId(orderId);

      // Find the order by orderId
      const order = await Order.findById(orderId);

      if (!order) {
          return res.status(404).json({ message: "Order not found" });
      }

      // Update the arrival date to the current date
      order.arrivalDate = new Date();

      // Save the updated order
      const updatedOrder = await order.save();

      res.json({
          message: "Arrival date updated to today's date",
          updatedOrder: {
              _id: updatedOrder._id,
              arrivalDate: updatedOrder.arrivalDate,
              // Include other relevant fields
          },
      });
  } catch (error) {
      console.error("Error updating arrival date:", error);
      res.status(500).json({ message: "Internal Server Error" });
  }
});





const getOrders = asyncHandler(async (req, res) => {
    const { id } = req.params;
    validateMongoObId(id);
  
    try {
      const user = await User.findById(id);
      
      // Assuming your orders are associated with the user's _id
      const userorders = await Order.find({ orderby: user._id })
        .populate("products.product")
        .populate("orderby")
        .exec();
  
      res.json(userorders);
    } catch (error) {
      throw new Error(error);
    }
  });

  const updateOrderStatus = asyncHandler(async (req, res) => {
    const { status } = req.body;
    const { id } = req.params;
    validateMongoObId(id);
    try {
      const updateOrderStatus = await Order.findByIdAndUpdate(
        id,
        {
          orderStatus: status,
          paymentIntent: {
            status: status,
          },
        },
        { new: true }
      );
      res.json(updateOrderStatus);
    } catch (error) {
      throw new Error(error);
    }
  });
  
const getallUser = asyncHandler( async (req,res) => {
    try{
        const getUsers = await User.find();
        res.json(getUsers);

    }catch(error){
        throw new Error(error);
    }
});
const getaUser = asyncHandler( async (req,res) => {
  const {id} = req.params;
  try{
      const getaUser = await User.findById( id );
      res.json({
          getaUser,
      });
  }catch(error){
      throw new Error(error);
  }
});
const updateUser = asyncHandler( async (req,res) => {
  const { id, fullName, phoneNumber, password } = req.params;
    
    try{
        const updateUser = await User.findByIdAndUpdate(id,{
            
            fullName: req?.params.fullName,
            phoneNumber: req?.params.phoneNumber,
            password: req?.params.password,
        },{
            new:true,
        }
        );
        res.json(
            updateUser
        );
    }catch(error){
        throw new Error(error);
    }
});

const transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: "khalilidema@gmail.com",
    pass: "inxq ketg vrfd bhgt"
  }
});



//new
const createOtp = async (params) => {
  const otp = otpGenerator.generate(4, {
    digits: true,
    lowerCaseAlphabets: false,
    upperCaseAlphabets: false,
    specialChars: false
  });
  const email=params.email;
  console.log(email);
  const findUser = await User.findOne({email:email});

  if(findUser!=null){
  const ttl = 5 * 60 * 1000;
  const expires = Date.now() + ttl;
  const data = `${params.email}.${otp}.${expires}`;
  const hash = crypto.createHmac("sha256", key).update(data).digest("hex");
  const fullHash = `${hash}.${expires}`;

  console.log(`Your OTP is ${otp}`);
  const mailOptions = {
    from: "khalilidema@gmail.com",
    to: "s11923701@stu.najah.edu",
    subject: "Your OTP",
    text: `Your OTP is: ${otp}`
  };
  
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error("Error sending OTP via email:", error);
    } else {
      console.log("OTP sent via email:", info.response);
    }
  });


  return fullHash;
}
else{
  console.log("User does not exist with the provided email.");
  return null;
}
};


const sendOtp = asyncHandler(async (req, res) => {
  try {
    const fullHash = await createOtp(req.body);
    res.status(200).send({
      message: "Success",
      data: fullHash
    });
  } catch (error) {
    // Handle any errors, you can log or send an error response here
    res.status(500).send({
      message: "Error",
      error: error.message
    });
  }
});


//new
const verifyOTP = async (params) => {
  const [hashValue, expires] = params.hash.split('.');
  const now = Date.now();

  if (now > parseInt(expires)) {
    throw new Error("OTP Expired");
  }

  const data = `${params.email}.${params.otp}.${expires}`;
  console.log(params.email);
  const newCalculateHash = crypto
    .createHmac("sha256", key)
    .update(data)
    .digest("hex");

  if (newCalculateHash === hashValue) {
    return "Success";
  }

  throw new Error("Invalid OTP");
};

const verify = asyncHandler(async (req, res) => {
  try {
    const result = await verifyOTP(req.body);
    res.status(200).send({
      message: "Success",
      data: result,
    });
  } catch (error) {
    res.status(500).send({
      message: "Error",
      error: error.message,
    });
  }
});


const updatePass = async (params) => {
  // Check if 'email' and 'newPassword' are provided in the 'params' object
  if (!params.email || !params.newPassword) {
    console.error("Both 'email' and 'newPassword' are required.");
    return;
  }

  const email = params.email;

  try {
    const user = await User.findOne({ email: email });

    if (!user) {
      // Handle the case where the user with the given email doesn't exist
      console.error('User with the provided email does not exist.');
      return;
    }

    // Assuming you have a new password in the params object
    const newPassword = params.newPassword;

    // Update the user's password
    user.password = newPassword;

    // Save the updated user
    await user.save();

    console.log('Password updated successfully');

    // Return an object containing the user's ID
    return { userId: user._id };
  } catch (error) {
    console.error('An error occurred while updating the password:', error);
    return { error: 'Password update failed' };
  }
};

const createPass = asyncHandler(async (req, res) => {
  try {
    const fullHash = await updatePass(req.body);
    res.status(200).send({
      message: "Success",
      data: fullHash
    });
  } catch (error) {
    // Handle any errors, you can log or send an error response here
    res.status(500).send({
      message: "Error",
      error: error.message
    });
  }
});

// Function to get user wishlist
const getUserWishlist = async (userId) => {
  try {
    const user = await User.findById(userId).populate('wishlist');
    return user.wishlist;
  } catch (error) {
    throw new Error(error);
  }
};

// Function to get user orders
const getUserOrders = async (userId) => {
  try {
    const user = await User.findById(userId);
    const userOrders = await Order.find({ orderby: user._id })
      .populate('products.product')
      .populate('orderby')
      .exec();
    return userOrders;
  } catch (error) {
    throw new Error(error);
  }
};

const generateRecommendations = asyncHandler(async (req, res) => {
  // Step 1: Feature Extraction
  const products = await Product.find();
  
  const recipes = await Recipe.find(); // Adjust the query based on your model

  const productsFeatures = products.map((product) => ({
    id: product._id,
    features: [
      // Convert price and numberOfBuy to numbers, handle NaN values
      isNaN(product.price) ? 0 : Number(product.price),
      isNaN(product.numberOfBuy) ? 0 : Number(product.numberOfBuy),
      hashString(product.type || 'food'), // Use a hash function for the string type
    ],
  }));
  

function hashString(s) {
  // Check if the input is a valid number
  if (/^-?\d*\.?\d+$/.test(s)) {
    return parseFloat(s);
  } else {
    // If not a valid number, generate a hash code for non-numeric types
    let hash = 0;
    for (let i = 0; i < s.length; i++) {
      const charCode = s.charCodeAt(i);
      hash = (hash << 5) - hash + charCode;
    }
    return hash;
  }
}

  const recipesFeatures = recipes.map((recipe) => ({
    id: recipe._id,
    features: [
      // Convert time, calo, prot to numbers, handle NaN values
      isNaN(recipe.time) ? 0 : Number(recipe.time),
      isNaN(recipe.calo) ? 0 : Number(recipe.calo),
      isNaN(recipe.prot) ? 0 : Number(recipe.prot),
      recipe.categories.length || 0,
      recipe.product.length || 0,
    ],
  }));
  console.log('Products Features:', productsFeatures.map((p) => p.features));
  console.log('Recipes Features:', recipesFeatures.map((r) => r.features));

  // Step 2: Combine Data
  const combinedData = productsFeatures.concat(recipesFeatures);

  // Step 3: User Preferences
  const userId = req.params.id;
  const userWishlist = await getUserWishlist(userId);

  const userOrders = await getUserOrders(userId);

  if (userWishlist.length === 0) {
    return res.status(404).json({ success: false, message: "User has no wishlist items." });
  }
  if (combinedData.length === 0) {
    return res.status(500).json({ success: false, message: "No data available for recommendations." });
  }

  // Step 4: KNN Algorithm
  function findKNN(data, queryPoint, k) {
    // Calculate distances between the query point and all data points
    const distances = data.map((dataPoint) => {
      const features1 = dataPoint.features;
      const features2 = queryPoint.features;
  
      console.log("fe1          "+features1);
      console.log("fe2          "+features2);
  
      return {
        dataPoint,
        distance: euclideanDistance(features1, features2), // Pass the arrays directly
      };
    });

    // Sort distances in ascending order
    distances.sort((a, b) => a.distance - b.distance);

    // Return the first K neighbors
    return distances.slice(0, k).map((neighbor) => neighbor.dataPoint);
  }
  function euclideanDistance(point1, point2) {
    console.log('Point 1:', point1);
    console.log('Point 2:', point2);
  
    if (!point1.features || !point2.features) {
      console.error('Features array is undefined for one or both points');
      console.error('Point 1 features:', point1.features);
      console.error('Point 2 features:', point2.features);
      throw new Error('Features array is undefined for one or both points');
    }
  
    if (point1.features.length !== point2.features.length) {
      console.error('Feature lengths are different for Euclidean distance calculation');
      console.error('Point 1 features length:', point1.features.length);
      console.error('Point 2 features length:', point2.features.length);
      throw new Error('Feature lengths must be the same for Euclidean distance calculation');
    }
  
    const squaredDifferences = point1.features.map((feature, index) => {
      const diff = feature - point2.features[index];
      return diff * diff;
    });
  
    const sumSquaredDifferences = squaredDifferences.reduce((sum, squaredDiff) => sum + squaredDiff, 0);
  
    return Math.sqrt(sumSquaredDifferences);
  }
  
  
  const userPreferences = userWishlist.map((wishlist) => {
    const product = products.find((p) => p && p._id && p._id.equals(wishlist._id));
  
    if (product) {
      // Product found, you can proceed with further actions
      console.log('Product found:', product);
  
      // Make sure to adjust the mapping based on the actual structure of the product
      const mappedFeatures = [
        product.price,
        product.numberOfBuy,
        hashString(product.type),
        product.totalrating ? parseFloat(product.totalrating) : 0,
        // Add other features as needed
      ];
  
      console.log('Mapped features:', mappedFeatures);
  
      return {
        id: wishlist._id,
        features: mappedFeatures,
      };
    } else {
      // Product not found or _id is empty, handle the case accordingly
      console.log('Product not found or _id is empty for wishlist item:', wishlist);
      return null;
    }
  });

  const aggregatedUserPreferences = {
    id: userId,
    features: userPreferences.reduce((acc, pref) => {
      return acc.map((val, index) => val + pref.features[index]);
    }, Array(userPreferences[0].features.length).fill(0)).map((val) => val / userPreferences.length),
  };
  const k = 3; // You can adjust this value
  if (k > combinedData.length) {
    return res.status(400).json({ success: false, message: "Invalid value of k for KNN. It should be less than or equal to the number of data points." });
  }

  // Find K-nearest neighbors
  const nearestNeighbors = findKNN(combinedData, aggregatedUserPreferences, k);
  // Step 5: Recommendation Generation
  const recommendations = nearestNeighbors.map((neighbor) => {
    // Identify whether the neighbor is a product or a recipe
    const isProduct = productsFeatures.some((p) => p.id.equals(neighbor.id));
    const isRecipe = recipesFeatures.some((r) => r.id.equals(neighbor.id));

    // Add logic to generate recommendations based on the neighbor type
    if (isProduct) {
      return products.find((p) => p._id.equals(neighbor.id));
    } else if (isRecipe) {
      return recipes.find((r) => r._id.equals(neighbor.id));
    }

    return null;
  });

  res.json({ success: true, recommendations });eeeeeee
});



module.exports = {
     createUser ,
     loginUserCtrl,
     userCart,
     getallUser,
     getaUser,
     updateUser,
     getUserCart,
     emptyCart,
     createOrder,
     getOrders,
     updateOrderStatus,
     getWishlist ,
     removeItemFromCart,
     signUp,
     sendOtp,
     verify,
     createPass,
     updateCartItem,
     updateArrivalDate,
     generateRecommendations
    };

