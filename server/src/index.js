const express = require("express");
const dbConnect = require("../config/dbConnect");
const app = express();
const dotenv = require("dotenv").config();
const PORT = process.env.PORT || 4000;//5000 because .env file
const authRouter = require("../routes/authRoute");
const bodyParser = require("body-parser");
const productRouter = require("../routes/productRoute");
const couponRouter = require("../routes/couponRoute");
const recipeRouter = require("../routes/recipeRoute");
const { notFound, errorHandler } = require("../middlewares/errorHandler");
const commentRouter = require("../routes/commentRout");
const pushNotificationRoute = require("../routes/pushNotificationRoute");


const morgan = require("morgan");
dbConnect();

app.use('/api/notification', pushNotificationRoute);
app.use(morgan("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use("/api/coupon",couponRouter);
app.use("/api/user" ,authRouter);
app.use("/api/product" ,productRouter);
app.use("/api/comment",commentRouter);
app.use("/api/recipe",recipeRouter);

app.use(notFound);
app.use(errorHandler);
app.use(express.json);


app.listen(PORT, () => {
  console.log(`Server is running at PORT ${PORT}`);
});






















