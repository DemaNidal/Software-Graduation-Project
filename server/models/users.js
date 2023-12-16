const mongoose = require('mongoose');
const bcrypt = require('bcrypt');



const userSchema = new mongoose.Schema({
    email: {
        type :String ,
        required : true
    },
    password: String
});


userSchema.pre('save', async function() {
    try {
        const user = this;
        const saltRounds = 10; // Adjust the number of rounds as needed
        const salt = await bcrypt.genSalt(saltRounds);
        const hashpass = await bcrypt.hash(user.password, salt);
        user.password = hashpass;
    } catch (e) {
        throw e;
    }
}); // This lines for incryoted password
module.exports = mongoose.model('users' , userSchema);


