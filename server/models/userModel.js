const mongoose = require("mongoose"); // Erase if already required
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");


// Declare the Schema of the Mongo model
var userSchema = new mongoose.Schema({
 
    user_id: {
        type: Number,
        unique: true,
        required: true,
      },
    email:{
        type:String,
        required:true,
        unique:true,
    },
    fullName:{
        type:String,
        required:true,
        unique:true,
    },
    password:{
        type:String,
        required:true,
    },
    livePlace: {
        type: String,
        required: true,
    },
    phoneNumber: {
        type: Number,
        required: true,
        unique: true
    },
    dateOfBirth: {
        type: Date,
    },
    isAdmin: {
        type: Boolean,
        required: true,
        default: false
    },
    role: {
        type:String,
        default:"user",
    },
    jwtToken: {
        type: String,
        default: null,
    },
    token: {
        type: String,
        default: null,
    },
    wishlist: [{type: mongoose.Schema.Types.ObjectId, ref: "Product" }],
    
   
},{timestamps:true,});

userSchema.pre('save' , async function (next) {
    const salt = await bcrypt.genSaltSync(10);
    this.password = await bcrypt.hash(this.password, salt);
});
userSchema.methods.isPasswordMatched = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword ,this.password);
};

userSchema.methods.generateAuthToken = async function () {
    const user = this;
    const token = jwt.sign(
      {
        _id: user._id,
        email: user.email,
        isAdmin: user.isAdmin,
      },
      process.env.JWT_SECRET, // Use environment variable for secret key
      { expiresIn: "1h" } // Token expires in 1 hour (you can adjust this)
    );
  
    user.jwtToken = token;
    await user.save();
    return token;
  };
  
//Export the model

const User = mongoose.model('User', userSchema);

module.exports = User;