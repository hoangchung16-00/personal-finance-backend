# Personal Finance Backend API Documentation

Base URL: `/api/v1`

## Quick Start

1. **Get an API Key**: Use Rails console to generate an API key for your user account
2. **Set Authorization Header**: Include your API key in all requests: `Authorization: Bearer <your_api_key>`
3. **Create Resources**: Start by creating accounts, categories, and transactions
4. **Filter & Query**: Use query parameters to filter transactions by date, type, or category

## Table of Contents

1. [Authentication](#authentication)
2. [Endpoints](#endpoints)
   - [Health Check](#health-check)
   - [Accounts](#accounts)
   - [Categories](#categories)
   - [Transactions](#transactions)
3. [HTTP Status Codes](#http-status-codes)
4. [Error Responses](#error-responses)
5. [Data Validation Rules](#data-validation-rules)
6. [Common Workflows](#common-workflows)
7. [Testing the API](#testing-the-api)
8. [Rate Limiting](#rate-limiting)
9. [Pagination](#pagination)
10. [CORS](#cors)
11. [Future Enhancements](#future-enhancements)

## Authentication

**API Key Authentication** is required for all endpoints.

### Getting an API Key

To use this API, you must have an API key. The API key should be included in the `Authorization` header of every request using the Bearer token format:

```
Authorization: Bearer <your_api_key>
```

### Example Request with Authentication

```bash
curl -X GET http://localhost:3000/api/v1/accounts \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

### Generating an API Key

API keys can be generated programmatically using the Rails console:

```ruby
# In Rails console (rails c)
user = User.find_by(email: "your_email@example.com")
api_key = user.generate_api_key
puts "Your API key: #{api_key}"
# Store this key securely - it won't be shown again!
```

### Security Notes

- **Store your API key securely** - treat it like a password
- API keys are hashed in the database using bcrypt (highly secure)
- Never commit API keys to version control
- Each user has one API key at a time; generating a new one invalidates the old one
- API keys do not expire but can be revoked

### Authentication Errors

If authentication fails, you'll receive a `401 Unauthorized` response:

```json
{
  "error": "Invalid or missing API key"
}
```

Common authentication issues:
- Missing `Authorization` header
- Invalid API key
- Revoked API key
- Malformed header (must be "Bearer <key>")

## Endpoints

### Health Check

#### Check API health status
```
GET /up
```

**Description:** Returns the health status of the API. This endpoint does not require authentication and can be used by load balancers and monitoring tools.

**Response (Success):**
```
Status: 200 OK
```

**Response (Failure):**
```
Status: 500 Internal Server Error
```

This endpoint is useful for:
- Load balancer health checks
- Monitoring and alerting systems
- Verifying the API is running and can connect to dependencies (database, etc.)

---

### Accounts

#### List all accounts
```
GET /api/v1/accounts
```

**Description:** Returns all accounts belonging to the authenticated user.

**Response (200 OK):**
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

**Example:**
```bash
curl -X GET http://localhost:3000/api/v1/accounts \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### Get account details
```
GET /api/v1/accounts/:id
```

**Description:** Returns details for a specific account belonging to the authenticated user.

**Parameters:**
- `id` (path parameter) - The account ID

**Response (200 OK):**
```json
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
```

**Example:**
```bash
curl -X GET http://localhost:3000/api/v1/accounts/1 \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### Create account
```
POST /api/v1/accounts
Content-Type: application/json
```

**Description:** Creates a new account for the authenticated user.

**Request Body:**
```json
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

**Required Fields:**
- `name` - Account name
- `account_type` - One of the valid account types

**Optional Fields:**
- `balance` - Initial balance (defaults to 0.0)
- `currency` - Currency code (defaults to "USD")
- `number` - Account number
- `bank_name` - Bank or institution name

**Account Types:**
- `checking`
- `savings`
- `credit_card`
- `investment`
- `cash`
- `other`

**Response (201 Created):**
```json
{
  "id": 2,
  "user_id": 1,
  "name": "Savings Account",
  "account_type": "savings",
  "balance": "10000.00",
  "currency": "USD",
  "number": "1234567890",
  "bank_name": "First Bank",
  "created_at": "2026-02-01T09:00:00Z",
  "updated_at": "2026-02-01T09:00:00Z"
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/v1/accounts \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "account": {
      "name": "Savings Account",
      "account_type": "savings",
      "balance": 10000.00,
      "currency": "USD"
    }
  }'
```

#### Update account
```
PATCH /api/v1/accounts/:id
Content-Type: application/json
```

**Description:** Updates an existing account belonging to the authenticated user.

**Parameters:**
- `id` (path parameter) - The account ID

**Request Body:**
```json
{
  "account": {
    "name": "Updated Account Name"
  }
}
```

**Updatable Fields:**
All account fields can be updated: `name`, `account_type`, `balance`, `currency`, `number`, `bank_name`

**Response (200 OK):**
```json
{
  "id": 1,
  "user_id": 1,
  "name": "Updated Account Name",
  "account_type": "checking",
  "balance": "5000.00",
  "currency": "USD",
  "number": "****1234",
  "bank_name": "First Bank",
  "created_at": "2026-02-01T08:00:00Z",
  "updated_at": "2026-02-01T10:00:00Z"
}
```

**Example:**
```bash
curl -X PATCH http://localhost:3000/api/v1/accounts/1 \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "account": {
      "name": "Updated Account Name"
    }
  }'
```

#### Delete account
```
DELETE /api/v1/accounts/:id
```

**Description:** Deletes an account belonging to the authenticated user.

**Parameters:**
- `id` (path parameter) - The account ID

**Response (204 No Content):**
```
No response body
```

**Note:** Deleting an account will also delete all associated transactions.

**Example:**
```bash
curl -X DELETE http://localhost:3000/api/v1/accounts/1 \
  -H "Authorization: Bearer your_api_key_here"
```

---

### Categories

#### List all categories
```
GET /api/v1/categories
```

**Description:** Returns all categories belonging to the authenticated user.

**Response (200 OK):**
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

**Example:**
```bash
curl -X GET http://localhost:3000/api/v1/categories \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### Get category details
```
GET /api/v1/categories/:id
```

**Description:** Returns details for a specific category belonging to the authenticated user.

**Parameters:**
- `id` (path parameter) - The category ID

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "Groceries",
  "user_id": 1,
  "created_at": "2026-02-01T08:00:00Z",
  "updated_at": "2026-02-01T08:00:00Z"
}
```

**Example:**
```bash
curl -X GET http://localhost:3000/api/v1/categories/1 \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### Create category
```
POST /api/v1/categories
Content-Type: application/json
```

**Description:** Creates a new category for the authenticated user.

**Request Body:**
```json
{
  "category": {
    "name": "Utilities"
  }
}
```

**Required Fields:**
- `name` - Category name (must be unique per user)

**Response (201 Created):**
```json
{
  "id": 2,
  "name": "Utilities",
  "user_id": 1,
  "created_at": "2026-02-01T09:00:00Z",
  "updated_at": "2026-02-01T09:00:00Z"
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/v1/categories \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "category": {
      "name": "Utilities"
    }
  }'
```

#### Update category
```
PATCH /api/v1/categories/:id
Content-Type: application/json
```

**Description:** Updates an existing category belonging to the authenticated user.

**Parameters:**
- `id` (path parameter) - The category ID

**Request Body:**
```json
{
  "category": {
    "name": "Food & Groceries"
  }
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "Food & Groceries",
  "user_id": 1,
  "created_at": "2026-02-01T08:00:00Z",
  "updated_at": "2026-02-01T10:00:00Z"
}
```

**Example:**
```bash
curl -X PATCH http://localhost:3000/api/v1/categories/1 \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "category": {
      "name": "Food & Groceries"
    }
  }'
```

#### Delete category
```
DELETE /api/v1/categories/:id
```

**Description:** Deletes a category belonging to the authenticated user.

**Parameters:**
- `id` (path parameter) - The category ID

**Response (204 No Content):**
```
No response body
```

**Note:** Deleting a category will set category_id to NULL for all associated transactions.

**Example:**
```bash
curl -X DELETE http://localhost:3000/api/v1/categories/1 \
  -H "Authorization: Bearer your_api_key_here"
```

---

### Transactions

#### List all transactions
```
GET /api/v1/transactions
```

**Description:** Returns all transactions for accounts belonging to the authenticated user, ordered by date (most recent first).

**Optional Query Parameters:**
- `start_date` (YYYY-MM-DD) - Filter by start date
- `end_date` (YYYY-MM-DD) - Filter by end date
- `transaction_type` (income|expense|transfer) - Filter by type
- `category_id` (integer) - Filter by category

**Examples:**
```bash
# All transactions
GET /api/v1/transactions

# Transactions in January 2026
GET /api/v1/transactions?start_date=2026-01-01&end_date=2026-01-31

# Only expenses
GET /api/v1/transactions?transaction_type=expense

# Transactions in "Groceries" category
GET /api/v1/transactions?category_id=1

# Combined filters
GET /api/v1/transactions?start_date=2026-01-01&end_date=2026-01-31&transaction_type=expense
```

**Response (200 OK):**
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

**cURL Example:**
```bash
curl -X GET "http://localhost:3000/api/v1/transactions?transaction_type=expense&start_date=2026-01-01" \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### List transactions for an account
```
GET /api/v1/accounts/:account_id/transactions
```

**Description:** Returns all transactions for a specific account belonging to the authenticated user, ordered by date (most recent first).

**Parameters:**
- `account_id` (path parameter) - The account ID

**Optional Query Parameters:**
Same as listing all transactions: `start_date`, `end_date`, `transaction_type`, `category_id`

**Response (200 OK):**
Same structure as listing all transactions.

**Example:**
```bash
curl -X GET http://localhost:3000/api/v1/accounts/1/transactions \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### Get transaction details
```
GET /api/v1/transactions/:id
```

**Description:** Returns details for a specific transaction belonging to the authenticated user's accounts.

**Parameters:**
- `id` (path parameter) - The transaction ID

**Response (200 OK):**
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

**Example:**
```bash
curl -X GET http://localhost:3000/api/v1/transactions/1 \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json"
```

#### Create transaction
```
POST /api/v1/accounts/:account_id/transactions
Content-Type: application/json
```

**Description:** Creates a new transaction for a specific account. The account balance will be automatically adjusted based on the transaction type.

**Parameters:**
- `account_id` (path parameter) - The account ID

**Request Body:**
```json
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

**Required Fields:**
- `amount` (must be > 0)
- `transaction_type`
- `date`
- `description`

**Optional Fields:**
- `category_id`
- `notes`
- `tags` (array of strings)

**Transaction Types:**
- `income` - Money coming in (increases balance)
- `expense` - Money going out (decreases balance)
- `transfer` - Money moved between accounts

**Automatic Balance Update:**
When a transaction is created, the associated account's balance is automatically updated:
- Income: Balance increases by amount
- Expense: Balance decreases by amount
- Transfer: Handled separately (future feature)

**Response (201 Created):**
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
  "updated_at": "2026-02-01T08:00:00Z"
}
```

**Example:**
```bash
curl -X POST http://localhost:3000/api/v1/accounts/1/transactions \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "transaction": {
      "amount": 50.00,
      "transaction_type": "expense",
      "date": "2026-02-01",
      "description": "Coffee shop",
      "category_id": 1
    }
  }'
```

#### Update transaction
```
PATCH /api/v1/transactions/:id
Content-Type: application/json
```

**Description:** Updates an existing transaction. The account balance will be automatically adjusted based on changes to the amount or transaction type.

**Parameters:**
- `id` (path parameter) - The transaction ID

**Request Body:**
```json
{
  "transaction": {
    "amount": 75.00,
    "description": "Updated description"
  }
}
```

**Updatable Fields:**
All transaction fields can be updated: `amount`, `transaction_type`, `date`, `description`, `notes`, `category_id`, `tags`

**Note:** Updating the amount will automatically adjust the account balance.

**Response (200 OK):**
```json
{
  "id": 1,
  "account_id": 1,
  "category_id": 1,
  "amount": "75.00",
  "transaction_type": "expense",
  "date": "2026-02-01",
  "description": "Updated description",
  "notes": "Weekly groceries",
  "tags": ["food", "weekly"],
  "created_at": "2026-02-01T08:00:00Z",
  "updated_at": "2026-02-01T10:00:00Z"
}
```

**Example:**
```bash
curl -X PATCH http://localhost:3000/api/v1/transactions/1 \
  -H "Authorization: Bearer your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
    "transaction": {
      "amount": 75.00,
      "description": "Updated description"
    }
  }'
```

#### Delete transaction
```
DELETE /api/v1/transactions/:id
```

**Description:** Deletes a transaction. The account balance will be automatically adjusted to reverse the transaction's effect.

**Parameters:**
- `id` (path parameter) - The transaction ID

**Response (204 No Content):**
```
No response body
```

**Note:** Deleting a transaction will automatically adjust the account balance.

**Example:**
```bash
curl -X DELETE http://localhost:3000/api/v1/transactions/1 \
  -H "Authorization: Bearer your_api_key_here"
```

---

## HTTP Status Codes

The API uses standard HTTP status codes to indicate the success or failure of requests:

### Success Codes

- **200 OK** - Request succeeded. Returns the requested resource.
- **201 Created** - Resource successfully created. Returns the new resource.
- **204 No Content** - Request succeeded but returns no content (typically for DELETE operations).

### Client Error Codes

- **400 Bad Request** - Invalid request format or missing required parameters.
- **401 Unauthorized** - Authentication failed or API key is invalid/missing.
- **404 Not Found** - The requested resource does not exist.
- **422 Unprocessable Entity** - Request format is valid but contains semantic errors (validation failures).

### Server Error Codes

- **500 Internal Server Error** - Something went wrong on the server side.

---

## Error Responses

### 400 Bad Request
Missing or invalid required parameters.

**Example Response:**
```json
{
  "error": "param is missing or the value is empty: transaction"
}
```

**Common Causes:**
- Missing required request body
- Empty or null required fields
- Invalid parameter format

### 401 Unauthorized
Authentication failed or API key is invalid/missing.

**Example Response:**
```json
{
  "error": "Invalid or missing API key"
}
```

**Common Causes:**
- Missing `Authorization` header
- Invalid API key
- Revoked API key
- Malformed header (must be "Bearer <key>")

### 404 Not Found
Resource not found.

**Example Response:**
```json
{
  "error": "Couldn't find Account with 'id'=999"
}
```

**Common Causes:**
- Invalid resource ID
- Attempting to access another user's resources
- Resource has been deleted

### 422 Unprocessable Entity
Validation errors. Request format is valid but semantic validation failed.

**Example Response:**
```json
{
  "error": "Validation failed: Amount must be greater than 0",
  "details": {
    "amount": ["must be greater than 0"]
  }
}
```

**Common Causes:**
- Invalid data values (e.g., negative amounts, invalid dates)
- Duplicate unique fields (e.g., duplicate category name)
- Invalid enum values (e.g., invalid account_type)

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

## Common Workflows

### Setting Up a New User

1. Create a user account (via Rails console for now)
2. Generate an API key for the user
3. Create initial accounts (checking, savings, etc.)
4. Create categories for organizing transactions

```bash
# In Rails console
user = User.create!(
  email: "user@example.com",
  first_name: "John",
  last_name: "Doe"
)
api_key = user.generate_api_key
puts "API Key: #{api_key}"
```

### Recording a Transaction

1. Ensure you have an account created
2. Optionally create a category for the transaction
3. POST to `/api/v1/accounts/:account_id/transactions`
4. The account balance updates automatically

### Generating a Monthly Report

1. Use the transactions list endpoint with date filters
2. Filter by `start_date` and `end_date` for the month
3. Optionally filter by `transaction_type` for income vs expenses
4. Aggregate the results in your application

```bash
# Get all expenses for January 2026
GET /api/v1/transactions?start_date=2026-01-01&end_date=2026-01-31&transaction_type=expense
```

### Tracking Spending by Category

1. Create categories for different spending types
2. Assign categories to transactions when creating them
3. Use the `category_id` filter to get transactions for specific categories
4. Calculate totals in your application

---

## Testing the API

### Using curl

```bash
# Set your API key as an environment variable
export API_KEY="your_api_key_here"

# Create an account
curl -X POST http://localhost:3000/api/v1/accounts \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "account": {
      "name": "My Checking",
      "account_type": "checking",
      "balance": 5000
    }
  }'

# List accounts
curl http://localhost:3000/api/v1/accounts \
  -H "Authorization: Bearer $API_KEY"

# Create a transaction
curl -X POST http://localhost:3000/api/v1/accounts/1/transactions \
  -H "Authorization: Bearer $API_KEY" \
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
curl http://localhost:3000/api/v1/transactions \
  -H "Authorization: Bearer $API_KEY"

# Filter transactions
curl "http://localhost:3000/api/v1/transactions?transaction_type=expense&start_date=2026-01-01" \
  -H "Authorization: Bearer $API_KEY"
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

1. ✅ **Authentication** - API key authentication is implemented
2. **Pagination** - For large datasets
3. **Rate Limiting** - Prevent abuse
4. **Webhooks** - Real-time notifications
5. **Bulk Operations** - Import/export transactions
6. **Reports** - Monthly summaries, spending analysis
7. **Budgets** - Budget tracking and alerts
8. **Recurring Transactions** - Auto-create regular transactions
9. **Multi-currency** - Currency conversion
10. **Attachments** - Receipt images
11. **API Key Scopes** - Granular permissions per API key
12. **Key Expiration** - Automatic API key rotation

---

## Support

For issues or questions, please refer to:
- `README.md` - Setup instructions
- `IMPLEMENTATION.md` - Implementation details
- `SECURITY.md` - Security considerations
