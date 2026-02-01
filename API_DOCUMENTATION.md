# Personal Finance Backend API Documentation

Base URL: `/api/v1`

## Authentication

⚠️ **Note**: Authentication is not yet implemented. All endpoints currently work without authentication.

**Before production deployment**, you must implement one of:
- JWT (JSON Web Tokens)
- API Keys
- OAuth 2.0

See `SECURITY.md` for detailed implementation guidance.

## Endpoints

### Accounts

#### List all accounts
```
GET /api/v1/accounts
```

**Response:**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "name": "Main Checking",
    "account_type": "checking",
    "balance": "5000.00",
    "currency": "USD",
    "number": "****1234",
    "bank_name": "First Bank",
    "created_at": "2026-02-01T08:00:00Z",
    "updated_at": "2026-02-01T08:00:00Z"
  }
]
```

#### Get account details
```
GET /api/v1/accounts/:id
```

#### Create account
```
POST /api/v1/accounts
Content-Type: application/json

{
  "account": {
    "name": "Savings Account",
    "account_type": "savings",
    "balance": 10000.00,
    "currency": "USD",
    "number": "1234567890",
    "bank_name": "First Bank"
  }
}
```

**Account Types:**
- `checking`
- `savings`
- `credit_card`
- `investment`
- `cash`
- `other`

#### Update account
```
PATCH /api/v1/accounts/:id
Content-Type: application/json

{
  "account": {
    "name": "Updated Account Name"
  }
}
```

#### Delete account
```
DELETE /api/v1/accounts/:id
```

**Note:** Deleting an account will also delete all associated transactions.

---

### Categories

#### List all categories
```
GET /api/v1/categories
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Groceries",
    "user_id": 1,
    "created_at": "2026-02-01T08:00:00Z",
    "updated_at": "2026-02-01T08:00:00Z"
  }
]
```

#### Get category details
```
GET /api/v1/categories/:id
```

#### Create category
```
POST /api/v1/categories
Content-Type: application/json

{
  "category": {
    "name": "Utilities"
  }
}
```

#### Update category
```
PATCH /api/v1/categories/:id
Content-Type: application/json

{
  "category": {
    "name": "Food & Groceries"
  }
}
```

#### Delete category
```
DELETE /api/v1/categories/:id
```

**Note:** Deleting a category will set category_id to NULL for all associated transactions.

---

### Transactions

#### List all transactions
```
GET /api/v1/transactions
```

**Optional Query Parameters:**
- `start_date` (YYYY-MM-DD) - Filter by start date
- `end_date` (YYYY-MM-DD) - Filter by end date
- `transaction_type` (income|expense|transfer) - Filter by type
- `category_id` (integer) - Filter by category

**Examples:**
```
# Transactions in January 2026
GET /api/v1/transactions?start_date=2026-01-01&end_date=2026-01-31

# Only expenses
GET /api/v1/transactions?transaction_type=expense

# Transactions in "Groceries" category
GET /api/v1/transactions?category_id=1

# Combined filters
GET /api/v1/transactions?start_date=2026-01-01&end_date=2026-01-31&transaction_type=expense
```

**Response:**
```json
[
  {
    "id": 1,
    "account_id": 1,
    "category_id": 1,
    "amount": "50.00",
    "transaction_type": "expense",
    "date": "2026-02-01",
    "description": "Grocery shopping",
    "notes": "Weekly groceries",
    "tags": ["food", "weekly"],
    "created_at": "2026-02-01T08:00:00Z",
    "updated_at": "2026-02-01T08:00:00Z",
    "category": {
      "id": 1,
      "name": "Groceries"
    },
    "account": {
      "id": 1,
      "name": "Main Checking"
    }
  }
]
```

#### List transactions for an account
```
GET /api/v1/accounts/:account_id/transactions
```

Same query parameters as listing all transactions.

#### Get transaction details
```
GET /api/v1/transactions/:id
```

**Response:**
```json
{
  "id": 1,
  "account_id": 1,
  "category_id": 1,
  "amount": "50.00",
  "transaction_type": "expense",
  "date": "2026-02-01",
  "description": "Grocery shopping",
  "notes": "Weekly groceries",
  "tags": ["food", "weekly"],
  "created_at": "2026-02-01T08:00:00Z",
  "updated_at": "2026-02-01T08:00:00Z",
  "category": {
    "id": 1,
    "name": "Groceries",
    "user_id": 1,
    "created_at": "2026-01-15T10:00:00Z",
    "updated_at": "2026-01-15T10:00:00Z"
  },
  "account": {
    "id": 1,
    "user_id": 1,
    "name": "Main Checking",
    "account_type": "checking",
    "balance": "4950.00",
    "currency": "USD",
    "number": "****1234",
    "bank_name": "First Bank",
    "created_at": "2026-01-01T08:00:00Z",
    "updated_at": "2026-02-01T08:30:00Z"
  }
}
```

#### Create transaction
```
POST /api/v1/accounts/:account_id/transactions
Content-Type: application/json

{
  "transaction": {
    "amount": 50.00,
    "transaction_type": "expense",
    "date": "2026-02-01",
    "description": "Grocery shopping",
    "notes": "Weekly groceries",
    "category_id": 1,
    "tags": ["food", "weekly"]
  }
}
```

**Transaction Types:**
- `income` - Money coming in (increases balance)
- `expense` - Money going out (decreases balance)
- `transfer` - Money moved between accounts

**Required Fields:**
- `amount` (must be > 0)
- `transaction_type`
- `date`
- `description`

**Optional Fields:**
- `category_id`
- `notes`
- `tags` (array of strings)

**Automatic Balance Update:**
When a transaction is created, the associated account's balance is automatically updated:
- Income: Balance increases by amount
- Expense: Balance decreases by amount
- Transfer: Handled separately (future feature)

#### Update transaction
```
PATCH /api/v1/transactions/:id
Content-Type: application/json

{
  "transaction": {
    "amount": 75.00,
    "description": "Updated description"
  }
}
```

**Note:** Updating the amount will automatically adjust the account balance.

#### Delete transaction
```
DELETE /api/v1/transactions/:id
```

**Note:** Deleting a transaction will automatically adjust the account balance.

---

## Error Responses

### 400 Bad Request
Missing required parameters.

```json
{
  "error": "param is missing or the value is empty: transaction"
}
```

### 404 Not Found
Resource not found.

```json
{
  "error": "Couldn't find Account with 'id'=999"
}
```

### 422 Unprocessable Entity
Validation errors.

```json
{
  "error": "Validation failed: Amount must be greater than 0",
  "details": {
    "amount": ["must be greater than 0"]
  }
}
```

---

## Data Validation Rules

### User
- `email` - Required, must be valid email format, unique
- `first_name` - Required
- `last_name` - Required

### Account
- `name` - Required
- `account_type` - Required, must be one of the valid types
- `balance` - Required, must be numeric (defaults to 0.0)
- `currency` - Required (defaults to "USD")

### Category
- `name` - Required, must be unique per user

### Transaction
- `amount` - Required, must be greater than 0
- `transaction_type` - Required, must be income/expense/transfer
- `date` - Required
- `description` - Required
- `category_id` - Optional

---

## Testing the API

### Using curl

```bash
# Create an account
curl -X POST http://localhost:3000/api/v1/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "account": {
      "name": "My Checking",
      "account_type": "checking",
      "balance": 5000
    }
  }'

# List accounts
curl http://localhost:3000/api/v1/accounts

# Create a transaction
curl -X POST http://localhost:3000/api/v1/accounts/1/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "transaction": {
      "amount": 50.00,
      "transaction_type": "expense",
      "date": "2026-02-01",
      "description": "Coffee shop"
    }
  }'

# List transactions
curl http://localhost:3000/api/v1/transactions

# Filter transactions
curl "http://localhost:3000/api/v1/transactions?transaction_type=expense&start_date=2026-01-01"
```

### Using Postman or Insomnia

1. Import the endpoints as a collection
2. Set base URL to `http://localhost:3000/api/v1`
3. Use JSON body for POST/PATCH requests
4. Add query parameters for filtering

---

## Rate Limiting

⚠️ **Not yet implemented**. Consider implementing rate limiting before production deployment.

Recommended: 100 requests per minute per user/API key.

---

## Pagination

⚠️ **Not yet implemented**. Large datasets may cause performance issues.

Consider implementing pagination for list endpoints:
```
GET /api/v1/transactions?page=1&per_page=20
```

---

## CORS

CORS is configured to allow cross-origin requests. See `config/initializers/cors.rb` for configuration.

---

## Future Enhancements

1. **Authentication** - JWT, API keys, or OAuth
2. **Pagination** - For large datasets
3. **Rate Limiting** - Prevent abuse
4. **Webhooks** - Real-time notifications
5. **Bulk Operations** - Import/export transactions
6. **Reports** - Monthly summaries, spending analysis
7. **Budgets** - Budget tracking and alerts
8. **Recurring Transactions** - Auto-create regular transactions
9. **Multi-currency** - Currency conversion
10. **Attachments** - Receipt images

---

## Support

For issues or questions, please refer to:
- `README.md` - Setup instructions
- `IMPLEMENTATION.md` - Implementation details
- `SECURITY.md` - Security considerations
