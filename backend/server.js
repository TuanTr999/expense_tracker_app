const express = require('express');
const cors = require('cors');
const admin = require("firebase-admin");

const serviceAccount = require("./expense-tracker-app-tuantr-firebase-adminsdk-fbsvc-eb1060f213.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();

app.use(cors());
app.use(express.json());

// IMPORT ROUTES
const transactionRoutes = require('./transaction.routes');
const categoryRoutes = require('./category.routes');
const budgetRoutes = require('./budget.routes');
const walletRoutes = require('./wallet.routes');
const userRoutes = require('./user.routes');

// USE ROUTES
app.use(transactionRoutes);
app.use(categoryRoutes);
app.use(budgetRoutes);
app.use(walletRoutes);
app.use(userRoutes);

app.listen(80, '0.0.0.0', () => console.log('Server running at http://0.0.0.0:80'));