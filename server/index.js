const express = require("express");
const { default: mongoose } = require("mongoose");
const authRouter = require("./routes/auth");

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());

app.use(authRouter);
const DB =
  "mongodb+srv://sumit9305:authentication@cluster0.hoa69v3.mongodb.net/?retryWrites=true&w=majority";

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connected to DB");
  })
  .catch((error) => {
    console.log(error);
  });
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
