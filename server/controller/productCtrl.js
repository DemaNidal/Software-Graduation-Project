const Product = require("../models/productModel");
const asyncHandler = require("express-async-handler");
const slugify = require("slugify");
const User = require("../models/userModel");
const Notifi = require("../models/notificationModel");
//const slugify = require("slugify");
const validateMongoDbId = require("../utils/validateMongodbid");
const { sendPushNotification } = require("../controller/pushNotificationController");

const createProduct = asyncHandler(async(req,res) => {
    try{
        if(req.body.name) {
            req.body.slug=slugify(req.body.name);
        }
        const newProduct = await Product.create(req.body);
        res.json({newProduct});
    }catch (error) {
        throw new Error(error);
    }
});

const updateProduct = asyncHandler(async (req, res) => {
  const id = req.params.id; // Access the 'id' parameter from req.params
  try {
    if (req.body.name) {
      req.body.slug = slugify(req.body.name);
    }

    // Use the correct query to find the product by its ID
    const updatedProduct = await Product.findOneAndUpdate({ _id: id }, req.body, {
      new: true,
    });

    if (!updatedProduct) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Find users whose wishlist includes the updated product
    const usersWithUpdatedProduct = await User.find({ wishlist: updatedProduct._id });

    // Now, send notifications to each user in the list
    for (const user of usersWithUpdatedProduct) {
      try {
        await sendPushNotification(user, updatedProduct);

        const notification = new Notifi({
          userId: user._id, // Assuming user._id is the MongoDB ObjectId of the user
          title: "Product Update Notification",
          body: `The product '${updatedProduct.name}' in your wishlist has been updated!`,
          data: {
            productId: String(updatedProduct._id),
            productName: String(updatedProduct.name),
            // Add more data as needed
          },
        });

        await notification.save();
      } catch (notificationError) {
        // Handle errors during notification sending or saving
        console.error('Error sending notification:', notificationError);
      }
    }

    res.json(updatedProduct);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

const updateAllProducts = asyncHandler(async (req, res) => {
  try {
    if (req.body.name) {
      req.body.slug = slugify(req.body.name);
    }

    // Use updateMany to update all products
    const updateResult = await Product.updateMany({}, { $set: req.body });

    if (updateResult.nModified === 0) {
      return res.status(404).json({ message: 'No products found to update' });
    }

    
  

      // Find all users
      const allUsers = await User.find();

      // Now, send notifications to each user in the list
      for (const user of allUsers) {
        try {
          await sendPushNotification(user);

          const notification = new Notifi({
            userId: user._id,
            title: "Sale!!",
            body: `The products have a big sale, check this!!`,
            data: {
              // You can add more data if needed
            },
          });

          await notification.save();
        } catch (notificationError) {
          // Handle errors during notification sending or saving
          console.error('Error sending notification:', notificationError);
        }
      }
    

    res.json({ message: 'All products updated and notifications sent successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});



const deleteProduct = asyncHandler(async (req, res) => {
    const id = req.params.id; // Access the 'id' parameter from req.params
    try {
        const deletedProduct = await Product.findOneAndDelete({ _id: id }); // Use { _id: id } to match by the product's ID
        if (!deletedProduct) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.json(deletedProduct);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});

const getaProduct = asyncHandler(async (req, res) => {
    const { id } = req.params;
    try {

        const findProduct = await Product.findById(id);
        if (!findProduct) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.json(findProduct);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
});

const getAllProduct = asyncHandler(async (req, res) => {
    const queryObj = {...req.query};
    const excludeFields = ['page','sort','limit','fields'];
    excludeFields.forEach((el) => delete queryObj[el]);


    console.log(queryObj, req.query);
    try {
        const getallProducts = await Product.find(queryObj);
        res.json(getallProducts);
    }
    catch (error) {
        throw new Error(error);
    }
});
const getBestSellers = asyncHandler(async (req, res, next) => {
    const limit = 10;
    try {
       // Define the limit here or pass it as a parameter to the function
      // Find products and sort them in descending order based on 'numberOfBuy'
      const bestSellers = await Product.find({})
        .sort({ numberOfBuy: -1 })
        .limit(limit);
  
      res.json(bestSellers); // Send the response
    } catch (error) {
      next(error); // Pass the error to the error handling middleware (asyncHandler)
    }
  });



  const addToWishlist = asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { prodId } = req.body;
    try {
      const user = await User.findById(id);
      const alreadyadded = user.wishlist.find((id) => id.toString() === prodId);
      if (alreadyadded) {
        let user = await User.findByIdAndUpdate(
          id,
          {
            $pull: { wishlist: prodId },
          },
          {
            new: true,
          }
        );
        res.json(user);
      } else {
        let user = await User.findByIdAndUpdate(
          id,
          {
            $push: { wishlist: prodId },
          },
          {
            new: true,
          }
        );
        res.json(user);
      }
    } catch (error) {
      throw new Error(error);
    }
  });

  
  const searchProduct = asyncHandler(async (req, res) => {
    let { query } = req.query;
    console.log('Received query:', query);

    // Check if query is undefined or empty
    if (!query || typeof query !== 'string') {
        return res.status(400).json({ message: 'Invalid search query' });
    }

    // Escape special characters in the search query
    query = query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

    try {
        const products = await Product.find({
            $or: [
                { name: { $regex: new RegExp(query, 'i') } },
            ],
        });
        return res.status(200).json(products);
    } catch (error) {
        return res.status(500).json({ message: 'Internal server error', error });
    }
});
const foodProduct = asyncHandler( async (req, res) => {
  try {
    const products = await Product.find();
    console.log(products);
    // Filter products based on type (for example, food)
    const foodProducts = products.filter(product => product.type === "food");
    
  
    // Return only food products
    res.json(foodProducts);
  }catch (error) {
    console.error(error);
    res.status(500).json({ msg: `Internal Server Error: ${error.message}` });
  }
  
});

const spiceProduct = asyncHandler( async (req, res) => {
  try {
    const products = await Product.find();
  
    // Filter products based on type (for example, food)
    const foodProducts = products.filter(product => product.type === "spices");
  
    // Return only food products
    res.json(foodProducts);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Internal Server Error" });
  }
});
const coffeeProduct= asyncHandler( async (req, res) => {
  try {
    const products = await Product.find();
  
    // Filter products based on type (for example, food)
    const foodProducts = products.filter(product => product.type === "coffe");
  
    // Return only food products
    res.json(foodProducts);
  } catch (error) {
    console.error(error);
    res.status(500).json({ msg: "Internal Server Error" });
  }
});

const rating = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const { star, prodId } = req.body;
  try {
    const product = await Product.findById(prodId);
    let alreadyRated = product.ratings.find(
      (userId) => userId.postedby.toString() === id.toString()
    );
    if (alreadyRated) {
      const updateRating = await Product.updateOne(
        {
          ratings: { $elemMatch: alreadyRated },
        },
        {
          $set: { "ratings.$.star": star,},
        },
        {
          new: true,
        }
      );
    } else {
      const rateProduct = await Product.findByIdAndUpdate(
        prodId,
        {
          $push: {
            ratings: {
              star: star,
              postedby: id,
            },
          },
        },
        {
          new: true,
        }
      );
    }
    const getallratings = await Product.findById(prodId);
    let totalRating = getallratings.ratings.length;
    let ratingsum = getallratings.ratings
      .map((item) => item.star)
      .reduce((prev, curr) => prev + curr, 0);
    let actualRating = Math.round(ratingsum / totalRating);
    let finalproduct = await Product.findByIdAndUpdate(
      prodId,
      {
        totalrating: actualRating,
      },
      { new: true }
    );
    res.json(finalproduct);
  } catch (error) {
    throw new Error(error);
  }
});

module.exports = { 
    createProduct , 
    getaProduct , 
    getAllProduct , 
    updateProduct, 
    deleteProduct,
    getBestSellers,
    addToWishlist,
    searchProduct,
    foodProduct,
    spiceProduct,
    coffeeProduct,
    rating,
    updateAllProducts
};