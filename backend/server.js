const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// IMPORT ROUTES
const transactionRoutes = require('./transaction.routes');
const categoryRoutes = require('./category.routes');
const budgetRoutes = require('./budget.routes');


// USE ROUTES
app.use(transactionRoutes);
app.use(categoryRoutes);
app.use(budgetRoutes);

app.listen(80, '0.0.0.0', () => console.log('Server running at http://0.0.0.0:80'));