const { default: mongoose } = require("mongoose");

// Assuming you have already connected to the database and defined the 'Product' model

const dbConnect = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URL, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      writeConcern: {
        j: true,
        w: "majority",
        wtimeout: 1000
      }
    });

  console.log("Database connected successfully");

    // // Access the database and collection here
    // const db = conn.connection.db;
    // const products = await db.collection('products').find().toArray();
    // const users = await db.collection('users').find().toArray();
    // const recipe = await db.collection('recipes').find().toArray();
    
    // const prices = [];
    
    // const isLikedBys = [];
    // const ratingss = [];
    // const recipes = [];
    // const types = [];//types for each product
    // const ids = [];//id for all products
    // const usersWishlist = [];//wishlist for each user
    // const usersid = [];//ids for users
    // const recipesid = [];//


    // // users.forEach(doc => {
      
    // //   let isLikedBy = doc.wishlist;
    // //   let id = doc._id;
    // //   if(isLikedBy ==undefined){
    // //     isLikedBy=[];
    // //   }
    // //   usersid.push(id);
    // //   usersWishlist.push(isLikedBy);

    // // });
    // // console.log(usersid);
    // // console.log(usersWishlist);
    // products.forEach(doc => {
    //   const id = doc._id;
    //   const price = doc.price;
    //   const type = doc.type;
    //   const isLikedBy = doc.isLikedBy;
    //   const ratings = doc.ratings;
    //   const productRecipe = doc.recipe;
    
    //   if (!ids.includes(id)) {
    //     ids.push(id);
    //   }
    //   // Save unique prices
    //   if (!prices.includes(price)) {
    //     prices.push(price);
    //   }
    
    //   // Save unique types
    //   if (!types.includes(type)) {
    //     types.push(type);
    //   }
    
    //   // Save unique isLikedBy values
    //   isLikedBy && isLikedBy.forEach(userId => {
    //     if (!isLikedBys.includes(userId)) {
    //       isLikedBys.push(userId);
    //     }
    //   });
    
    //   // Save unique ratings
    //   ratings && ratings.forEach(rating => {
    //     const postedBy = rating.postedby;
    //     if (!ratingss.some(r => r.star === rating.star && r.postedby === postedBy)) {
    //       ratingss.push({ star: rating.star, postedby: postedBy });
    //     }
    //   });
    
    //   // Save unique recipe IDs
    //   productRecipe && productRecipe.forEach(recipeId => {
    //     if (!recipes.includes(recipeId)) {
    //       recipes.push(recipeId);
    //     }
    //   });
    // });
    // console.log('Unique ids:', ids);
    // console.log('Unique Prices:', prices);
    // console.log('Unique Types:', types);
    // console.log('Unique isLikedBys:', isLikedBys);
    // console.log('Unique Ratings:', ratingss);
    // console.log('Unique Recipes:', recipes);



  } catch (error) {
    console.error("Database error:", error);
    throw error;
  }
};




module.exports = dbConnect;
