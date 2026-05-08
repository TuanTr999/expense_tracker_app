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
app.use('/api', budgetRoutes);

app.listen(3000, '0.0.0.0', () => console.log('Server running at http://0.0.0.0:3000'));