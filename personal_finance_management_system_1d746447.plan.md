---
name: Personal Finance Management System
overview: Build a full-stack personal financial management website with Ruby on Rails backend and AngularJS frontend, featuring income/expense tracking, budgeting, reports, categories, recurring transactions, and savings goals with user authentication.
todos:
  - id: setup-backend
    content: Initialize Rails API project with PostgreSQL, configure CORS, and set up authentication (Devise Token Auth)
    status: pending
  - id: setup-frontend
    content: Initialize AngularJS application structure with routing and HTTP service setup
    status: pending
  - id: database-schema
    content: Create database migrations for users, categories, transactions, budgets, recurring_transactions, and savings_goals
    status: pending
    dependencies:
      - setup-backend
  - id: models-associations
    content: Implement Rails models with associations, validations, and scopes
    status: pending
    dependencies:
      - database-schema
  - id: auth-api
    content: Implement authentication API endpoints (signup, login, logout, current user)
    status: pending
    dependencies:
      - models-associations
  - id: transactions-api
    content: Build transactions CRUD API with filtering and summary endpoints
    status: pending
    dependencies:
      - auth-api
  - id: categories-api
    content: Implement categories CRUD API with user scoping
    status: pending
    dependencies:
      - auth-api
  - id: budgets-api
    content: Create budgets API with progress tracking endpoints
    status: pending
    dependencies:
      - categories-api
      - transactions-api
  - id: recurring-api
    content: Build recurring transactions API and background job for auto-generation
    status: pending
    dependencies:
      - transactions-api
  - id: goals-api
    content: Implement savings goals API with contribution tracking
    status: pending
    dependencies:
      - auth-api
  - id: reports-api
    content: Create reports API endpoints for income/expense, category analysis, trends, and cashflow
    status: pending
    dependencies:
      - transactions-api
      - categories-api
  - id: frontend-auth
    content: Build AngularJS authentication components (login, signup) and auth service
    status: pending
    dependencies:
      - setup-frontend
      - auth-api
  - id: frontend-transactions
    content: Create transactions UI components with CRUD operations and filters
    status: pending
    dependencies:
      - frontend-auth
      - transactions-api
  - id: frontend-categories
    content: Build categories management UI with color/icon selection
    status: pending
    dependencies:
      - frontend-auth
      - categories-api
  - id: frontend-budgets
    content: Implement budgets UI with progress visualization and alerts
    status: pending
    dependencies:
      - frontend-auth
      - budgets-api
  - id: frontend-recurring
    content: Create recurring transactions management interface
    status: pending
    dependencies:
      - frontend-auth
      - recurring-api
  - id: frontend-goals
    content: Build savings goals UI with progress tracking and contribution forms
    status: pending
    dependencies:
      - frontend-auth
      - goals-api
  - id: frontend-reports
    content: Implement reports dashboard with charts (Chart.js) and date range filters
    status: pending
    dependencies:
      - frontend-auth
      - reports-api
  - id: dashboard
    content: Create main dashboard component showing overview, recent transactions, and quick stats
    status: pending
    dependencies:
      - frontend-transactions
      - frontend-budgets
      - frontend-goals
---

# Personal Financial Management System

## Architecture Overview

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│   AngularJS     │◄───────►│  Rails API      │◄───────►│   PostgreSQL    │
│   Frontend      │  HTTP   │  Backend        │   SQL   │   Database      │
│                 │         │                 │         │                 │
└─────────────────┘         └─────────────────┘         └─────────────────┘
```

## Technology Stack

- **Backend**: Ruby on Rails 7+ (API mode)
- **Frontend**: AngularJS 1.x
- **Database**: PostgreSQL
- **Authentication**: Devise Token Auth or JWT
- **API Format**: JSON

## Database Schema

### Core Tables

**users** (authentication)

- id, email, encrypted_password, created_at, updated_at

**categories**

- id, user_id, name, type (income/expense), color, icon, created_at, updated_at

**transactions**

- id, user_id, category_id, amount, description, transaction_date, type (income/expense), created_at, updated_at

**budgets**

- id, user_id, category_id, amount, period (monthly/yearly), start_date, end_date, created_at, updated_at

**recurring_transactions**

- id, user_id, category_id, amount, description, frequency (daily/weekly/monthly/yearly), next_occurrence, end_date, created_at, updated_at

**savings_goals**

- id, user_id, name, target_amount, current_amount, target_date, description, created_at, updated_at

**budget_transactions** (junction table for budget vs actual)

- id, budget_id, transaction_id, created_at

## Project Structure

```
personal-finance/
├── backend/                    # Rails API
│   ├── app/
│   │   ├── controllers/
│   │   │   ├── api/
│   │   │   │   ├── v1/
│   │   │   │   │   ├── auth_controller.rb
│   │   │   │   │   ├── transactions_controller.rb
│   │   │   │   │   ├── categories_controller.rb
│   │   │   │   │   ├── budgets_controller.rb
│   │   │   │   │   ├── recurring_transactions_controller.rb
│   │   │   │   │   ├── savings_goals_controller.rb
│   │   │   │   │   └── reports_controller.rb
│   │   ├── models/
│   │   │   ├── user.rb
│   │   │   ├── category.rb
│   │   │   ├── transaction.rb
│   │   │   ├── budget.rb
│   │   │   ├── recurring_transaction.rb
│   │   │   └── savings_goal.rb
│   │   └── serializers/       # JSON serializers
│   ├── config/
│   │   ├── routes.rb
│   │   └── database.yml
│   └── db/
│       └── migrate/
│
└── frontend/                   # AngularJS app
    ├── app/
    │   ├── components/
    │   │   ├── auth/
    │   │   ├── dashboard/
    │   │   ├── transactions/
    │   │   ├── categories/
    │   │   ├── budgets/
    │   │   ├── recurring/
    │   │   ├── goals/
    │   │   └── reports/
    │   ├── services/
    │   │   ├── api.service.js
    │   │   ├── auth.service.js
    │   │   └── transaction.service.js
    │   ├── app.js
    │   └── app.config.js
    ├── assets/
    └── index.html
```

## Core Features & Requirements

### Feature 1: User Authentication & Authorization

**Description**: Secure user registration, login, logout, and session management.

**User Stories**:

- As a new user, I want to register with email and password so I can access my personal finance data
- As a user, I want to log in securely so my data remains private
- As a user, I want to log out so I can protect my account on shared devices
- As a user, I want my session to persist across browser refreshes

**Functional Requirements**:

- User registration with email validation and password strength requirements (min 8 characters)
- Email uniqueness validation
- Secure password hashing using bcrypt
- JWT token-based authentication
- Token refresh mechanism
- Password reset functionality (optional for MVP)
- Session timeout handling

**API Endpoints**:

- POST `/api/v1/auth/signup` - Register new user
- POST `/api/v1/auth/login` - Authenticate user
- DELETE `/api/v1/auth/logout` - Invalidate session
- GET `/api/v1/auth/me` - Get current authenticated user

**UI Requirements**:

- Login page with email/password fields
- Registration page with validation feedback
- Protected routes that redirect to login if not authenticated
- User profile display in navigation
- Logout button in header

**Files**: `backend/app/controllers/api/v1/auth_controller.rb`, `frontend/app/components/auth/`

---

### Feature 2: Income & Expense Tracking

**Description**: Core functionality to record, view, edit, and delete financial transactions (income and expenses).

**User Stories**:

- As a user, I want to add income transactions so I can track money coming in
- As a user, I want to add expense transactions so I can track money going out
- As a user, I want to categorize transactions so I can understand my spending patterns
- As a user, I want to filter transactions by date, category, and type so I can find specific entries
- As a user, I want to edit or delete transactions so I can correct mistakes
- As a user, I want to see a summary of my income vs expenses so I know my financial status

**Functional Requirements**:

- Create transaction with: amount (positive decimal), description (text), category (required), transaction date (defaults to today), type (income/expense)
- List transactions with pagination (20 per page)
- Filter by: date range, category, type (income/expense), search by description
- Sort by: date (newest/oldest), amount (high/low)
- Edit existing transactions
- Delete transactions with confirmation
- Calculate totals: total income, total expenses, net balance for selected period
- Validate: amount must be positive, category must exist and belong to user, date cannot be in future (configurable)

**API Endpoints**:

- GET `/api/v1/transactions` - List transactions (query params: page, per_page, start_date, end_date, category_id, type, search)
- POST `/api/v1/transactions` - Create transaction
- GET `/api/v1/transactions/:id` - Get single transaction
- PUT `/api/v1/transactions/:id` - Update transaction
- DELETE `/api/v1/transactions/:id` - Delete transaction
- GET `/api/v1/transactions/summary` - Get totals (query params: start_date, end_date)

**UI Requirements**:

- Transaction list view with table/card layout
- Add transaction form (modal or dedicated page) with:
  - Type toggle (Income/Expense)
  - Amount input with currency formatting
  - Category dropdown/selector
  - Description textarea
  - Date picker
- Edit transaction inline or via modal
- Delete confirmation dialog
- Filter panel with date range picker, category selector, type selector
- Summary cards showing: Total Income, Total Expenses, Net Balance
- Empty state when no transactions exist

**Files**: `backend/app/controllers/api/v1/transactions_controller.rb`, `frontend/app/components/transactions/`

---

### Feature 3: Categories Management

**Description**: Create and manage custom categories for organizing transactions.

**User Stories**:

- As a user, I want to create custom categories so I can organize my transactions my way
- As a user, I want to assign colors and icons to categories so I can visually distinguish them
- As a user, I want to edit category names and colors so I can refine my organization
- As a user, I want to delete categories so I can remove unused ones
- As a user, I want separate categories for income and expenses so I can properly categorize transactions

**Functional Requirements**:

- Create category with: name (required, unique per user), type (income/expense), color (hex code), icon (string identifier)
- List all user categories grouped by type
- Edit category name, color, and icon
- Delete category with option to reassign existing transactions to another category
- Prevent deletion if category has transactions (unless reassigning)
- Default categories created for new users (e.g., Salary, Food, Transportation, etc.)

**API Endpoints**:

- GET `/api/v1/categories` - List user categories (query param: type)
- POST `/api/v1/categories` - Create category
- GET `/api/v1/categories/:id` - Get single category
- PUT `/api/v1/categories/:id` - Update category
- DELETE `/api/v1/categories/:id` - Delete category (body: reassign_to_category_id)

**UI Requirements**:

- Category list view showing all categories with color indicators
- Add category form with:
  - Name input
  - Type selector (Income/Expense)
  - Color picker
  - Icon selector (grid of icons)
- Edit category inline or via modal
- Delete confirmation with transaction count and reassignment option
- Visual category selector in transaction forms (color-coded buttons/cards)

**Files**: `backend/app/controllers/api/v1/categories_controller.rb`, `frontend/app/components/categories/`

---

### Feature 4: Budget Planning & Monitoring

**Description**: Set spending budgets by category and track progress against actual spending.

**User Stories**:

- As a user, I want to set a monthly budget for a category so I can control my spending
- As a user, I want to see how much I've spent vs my budget so I know if I'm on track
- As a user, I want to see budget progress visually so I can quickly understand my status
- As a user, I want to receive alerts when I'm approaching or exceeding my budget
- As a user, I want to create budgets for different time periods so I can plan ahead

**Functional Requirements**:

- Create budget with: category (required), amount (positive decimal), period (monthly/yearly), start_date, end_date
- Calculate actual spending for budget period from transactions
- Calculate remaining budget amount
- Calculate percentage used
- Budget status: On Track (< 80%), Warning (80-100%), Exceeded (> 100%)
- List budgets with current period status
- Edit budget amount and dates
- Delete budget
- Support multiple budgets per category (different periods)

**API Endpoints**:

- GET `/api/v1/budgets` - List budgets (query params: period, category_id)
- POST `/api/v1/budgets` - Create budget
- GET `/api/v1/budgets/:id` - Get single budget
- PUT `/api/v1/budgets/:id` - Update budget
- DELETE `/api/v1/budgets/:id` - Delete budget
- GET `/api/v1/budgets/:id/progress` - Get budget progress details

**UI Requirements**:

- Budget list view with progress bars
- Add budget form with:
  - Category selector
  - Amount input
  - Period selector (Monthly/Yearly)
  - Date range picker
- Progress visualization:
  - Progress bar (green/yellow/red based on status)
  - Amount spent vs budget amount
  - Percentage indicator
  - Days remaining in period
- Budget cards/widgets on dashboard
- Alert badges for exceeded budgets

**Files**: `backend/app/controllers/api/v1/budgets_controller.rb`, `frontend/app/components/budgets/`

---

### Feature 5: Financial Reports & Analytics

**Description**: Generate visual reports and analytics to understand financial patterns and trends.

**User Stories**:

- As a user, I want to see income vs expenses over time so I can track my financial health
- As a user, I want to see spending breakdown by category so I know where my money goes
- As a user, I want to see monthly trends so I can identify patterns
- As a user, I want to export reports so I can share or archive them
- As a user, I want to filter reports by date range so I can analyze specific periods

**Functional Requirements**:

- Income vs Expense Report:
  - Compare income and expenses over selected period
  - Group by day/week/month
  - Show net balance trend
- Category Spending Report:
  - Pie chart showing percentage by category
  - Bar chart showing amounts by category
  - Filter by expense type only
- Trends Analysis:
  - Monthly income/expense trends
  - Year-over-year comparison
  - Average monthly spending by category
- Cash Flow Report:
  - Daily/weekly/monthly cash flow
  - Running balance calculation
  - Identify positive/negative periods

**API Endpoints**:

- GET `/api/v1/reports/income_expense` - Income vs expense (query params: start_date, end_date, group_by)
- GET `/api/v1/reports/by_category` - Spending by category (query params: start_date, end_date, type)
- GET `/api/v1/reports/trends` - Trends analysis (query params: period, compare_year)
- GET `/api/v1/reports/cashflow` - Cash flow report (query params: start_date, end_date, frequency)

**UI Requirements**:

- Reports dashboard page
- Date range selector (preset: This Month, Last Month, This Year, Custom)
- Chart visualizations:
  - Line chart for income/expense trends
  - Pie chart for category breakdown
  - Bar chart for category comparison
  - Area chart for cash flow
- Export options (PDF, CSV) - optional for MVP
- Report cards with key metrics
- Responsive charts for mobile

**Files**: `backend/app/controllers/api/v1/reports_controller.rb`, `frontend/app/components/reports/`

---

### Feature 6: Recurring Transactions

**Description**: Automate recurring income and expense entries (subscriptions, bills, salary).

**User Stories**:

- As a user, I want to set up recurring transactions so I don't have to manually enter them each time
- As a user, I want recurring transactions to automatically create entries so I don't forget
- As a user, I want to manage recurring transactions so I can update or cancel subscriptions
- As a user, I want to see when the next occurrence will be created so I can plan ahead

**Functional Requirements**:

- Create recurring transaction with: category, amount, description, frequency (daily/weekly/monthly/yearly), start_date, next_occurrence, end_date (optional)
- Auto-generate transactions based on frequency
- Background job runs daily to check and create pending transactions
- Manual trigger to generate next occurrence immediately
- Edit recurring transaction (updates future occurrences)
- Delete recurring transaction (option to keep existing transactions or delete all)
- List recurring transactions with next occurrence date
- Support for different day-of-month/week settings

**API Endpoints**:

- GET `/api/v1/recurring_transactions` - List recurring transactions
- POST `/api/v1/recurring_transactions` - Create recurring transaction
- GET `/api/v1/recurring_transactions/:id` - Get single recurring transaction
- PUT `/api/v1/recurring_transactions/:id` - Update recurring transaction
- DELETE `/api/v1/recurring_transactions/:id` - Delete recurring transaction
- POST `/api/v1/recurring_transactions/:id/generate` - Manually generate next occurrence

**UI Requirements**:

- Recurring transactions list view
- Add recurring transaction form with:
  - Category selector
  - Amount input
  - Description
  - Frequency selector (Daily/Weekly/Monthly/Yearly)
  - Start date picker
  - End date picker (optional)
- Display next occurrence date
- Toggle active/inactive status
- Manual "Generate Now" button
- Visual indicator for active vs paused recurring transactions

**Files**: `backend/app/controllers/api/v1/recurring_transactions_controller.rb`, `backend/app/jobs/recurring_transaction_job.rb`, `frontend/app/components/recurring/`

---

### Feature 7: Savings Goals

**Description**: Set and track progress toward financial savings goals.

**User Stories**:

- As a user, I want to create savings goals so I can plan for future expenses
- As a user, I want to track my progress toward goals so I know how close I am
- As a user, I want to add contributions to goals so I can update my progress
- As a user, I want to see visual progress indicators so I can stay motivated
- As a user, I want to set target dates so I have deadlines to work toward

**Functional Requirements**:

- Create savings goal with: name (required), target_amount (positive decimal), target_date (optional), description, current_amount (defaults to 0)
- Add contribution to goal (increases current_amount)
- Calculate progress percentage (current_amount / target_amount * 100)
- Calculate days remaining until target date
- Calculate required monthly contribution to meet goal
- Edit goal details (name, target_amount, target_date, description)
- Delete goal
- Mark goal as achieved when current_amount >= target_amount

**API Endpoints**:

- GET `/api/v1/savings_goals` - List savings goals
- POST `/api/v1/savings_goals` - Create savings goal
- GET `/api/v1/savings_goals/:id` - Get single goal
- PUT `/api/v1/savings_goals/:id` - Update goal
- DELETE `/api/v1/savings_goals/:id` - Delete goal
- POST `/api/v1/savings_goals/:id/contribute` - Add contribution (body: amount, date)

**UI Requirements**:

- Savings goals list view
- Add goal form with:
  - Name input
  - Target amount input
  - Target date picker (optional)
  - Description textarea
- Goal card/widget showing:
  - Progress bar (percentage)
  - Current amount vs target amount
  - Days remaining
  - Required monthly contribution
  - Achievement status badge
- Add contribution form (modal or inline)
- Visual progress indicators (circular progress, progress bar)
- Goal cards on dashboard

**Files**: `backend/app/controllers/api/v1/savings_goals_controller.rb`, `frontend/app/components/goals/`

---

### Feature 8: Dashboard Overview

**Description**: Centralized dashboard showing financial overview and quick access to key features.

**User Stories**:

- As a user, I want to see my financial overview at a glance so I understand my current status
- As a user, I want quick access to recent transactions so I can review them
- As a user, I want to see budget status so I know if I'm overspending
- As a user, I want to see my savings goals progress so I stay motivated

**Functional Requirements**:

- Display current month summary:
  - Total income
  - Total expenses
  - Net balance
  - Budget status (on track/warning/exceeded count)
- Show recent transactions (last 5-10)
- Display active budgets with quick status
- Show savings goals with progress
- Quick stats: transactions this month, categories used, etc.

**UI Requirements**:

- Dashboard layout with widgets/cards
- Summary cards at top (income, expenses, balance)
- Recent transactions list
- Budget status widgets
- Savings goals progress widgets
- Quick action buttons (Add Transaction, Create Budget, etc.)
- Responsive grid layout

**Files**: `frontend/app/components/dashboard/`

---

## Feature Implementation

### 1. User Authentication (`backend/app/controllers/api/v1/auth_controller.rb`)

- POST `/api/v1/auth/signup` - User registration
- POST `/api/v1/auth/login` - User login
- DELETE `/api/v1/auth/logout` - User logout
- GET `/api/v1/auth/me` - Get current user

### 2. Income & Expense Tracking (`backend/app/controllers/api/v1/transactions_controller.rb`)

- GET `/api/v1/transactions` - List all transactions (with filters: date range, category, type)
- POST `/api/v1/transactions` - Create transaction
- GET `/api/v1/transactions/:id` - Get single transaction
- PUT `/api/v1/transactions/:id` - Update transaction
- DELETE `/api/v1/transactions/:id` - Delete transaction
- GET `/api/v1/transactions/summary` - Get income/expense totals by period

**Frontend**: `frontend/app/components/transactions/` - CRUD interface with date picker, category selector, amount input

### 3. Categories Management (`backend/app/controllers/api/v1/categories_controller.rb`)

- GET `/api/v1/categories` - List user categories
- POST `/api/v1/categories` - Create category
- PUT `/api/v1/categories/:id` - Update category
- DELETE `/api/v1/categories/:id` - Delete category (with transaction reassignment)

**Frontend**: `frontend/app/components/categories/` - Category management with color/icon picker

### 4. Budget Planning (`backend/app/controllers/api/v1/budgets_controller.rb`)

- GET `/api/v1/budgets` - List budgets
- POST `/api/v1/budgets` - Create budget
- PUT `/api/v1/budgets/:id` - Update budget
- DELETE `/api/v1/budgets/:id` - Delete budget
- GET `/api/v1/budgets/:id/progress` - Get budget vs actual spending

**Frontend**: `frontend/app/components/budgets/` - Budget creation, progress bars, alerts

### 5. Financial Reports (`backend/app/controllers/api/v1/reports_controller.rb`)

- GET `/api/v1/reports/income_expense` - Income vs expense over time
- GET `/api/v1/reports/by_category` - Spending by category (pie/bar charts)
- GET `/api/v1/reports/trends` - Monthly/yearly trends
- GET `/api/v1/reports/cashflow` - Cash flow analysis

**Frontend**: `frontend/app/components/reports/` - Charts using Chart.js or similar, date range filters

### 6. Recurring Transactions (`backend/app/controllers/api/v1/recurring_transactions_controller.rb`)

- GET `/api/v1/recurring_transactions` - List recurring transactions
- POST `/api/v1/recurring_transactions` - Create recurring transaction
- PUT `/api/v1/recurring_transactions/:id` - Update recurring transaction
- DELETE `/api/v1/recurring_transactions/:id` - Delete recurring transaction
- POST `/api/v1/recurring_transactions/:id/generate` - Manually generate next occurrence

**Background Job**: Daily job to auto-generate transactions from recurring entries

**Frontend**: `frontend/app/components/recurring/` - Recurring transaction management

### 7. Savings Goals (`backend/app/controllers/api/v1/savings_goals_controller.rb`)

- GET `/api/v1/savings_goals` - List savings goals
- POST `/api/v1/savings_goals` - Create goal
- PUT `/api/v1/savings_goals/:id` - Update goal
- DELETE `/api/v1/savings_goals/:id` - Delete goal
- POST `/api/v1/savings_goals/:id/contribute` - Add contribution to goal

**Frontend**: `frontend/app/components/goals/` - Goal tracking with progress visualization

## Implementation Details

### Backend Setup

1. Initialize Rails API: `rails new backend --api --database=postgresql`
2. Add gems: `devise_token_auth`, `rack-cors`, `active_model_serializers`
3. Configure CORS for AngularJS frontend
4. Set up authentication with Devise Token Auth
5. Create models with associations and validations
6. Implement controllers with JSON responses
7. Add pagination for list endpoints
8. Set up background jobs (Sidekiq/ActiveJob) for recurring transactions

### Frontend Setup

1. Initialize AngularJS app structure
2. Configure routing (`ui-router` or `ngRoute`)
3. Set up HTTP interceptor for authentication tokens
4. Create service layer for API communication
5. Implement components for each feature module
6. Add form validation and error handling
7. Integrate charting library (Chart.js/D3.js)
8. Responsive design with CSS framework (Bootstrap/Material)

### Security Considerations

- JWT token authentication
- CSRF protection
- Input validation and sanitization
- SQL injection prevention (ActiveRecord)
- Rate limiting on API endpoints
- Password encryption (bcrypt)

### Key Files to Create

**Backend**:

- `backend/config/routes.rb` - API route definitions
- `backend/app/models/user.rb` - User model with associations
- `backend/app/models/transaction.rb` - Transaction model with validations
- `backend/app/controllers/api/v1/base_controller.rb` - Base API controller
- `backend/app/controllers/application_controller.rb` - Auth handling

**Frontend**:

- `frontend/app/app.js` - Main AngularJS module
- `frontend/app/services/api.service.js` - HTTP service wrapper
- `frontend/app/services/auth.service.js` - Authentication service
- `frontend/app/components/dashboard/dashboard.controller.js` - Main dashboard
- `frontend/index.html` - Entry point

## Development Phases

1. **Phase 1**: Backend setup, authentication, basic CRUD for transactions
2. **Phase 2**: Categories, budgets, and basic reports
3. **Phase 3**: Recurring transactions and savings goals
4. **Phase 4**: Advanced reports, charts, and UI polish
5. **Phase 5**: Testing and optimization

## Non-Functional Requirements

### Performance

- API response time < 200ms for standard queries
- Support pagination for large datasets (transactions, reports)
- Lazy loading for charts and heavy visualizations
- Database indexing on frequently queried fields (user_id, transaction_date, category_id)

### Scalability

- Support multiple users with data isolation
- Efficient database queries with proper joins and eager loading
- Background job processing for recurring transactions
- API rate limiting (100 requests per minute per user)

### Usability

- Responsive design (mobile, tablet, desktop)
- Intuitive navigation and user flows
- Form validation with clear error messages
- Loading states and feedback for async operations
- Accessible UI (WCAG 2.1 Level AA compliance)

### Security

- HTTPS only in production
- Password encryption (bcrypt, minimum 8 characters)
- JWT token expiration (24 hours, refreshable)
- Input sanitization and validation
- SQL injection prevention (ActiveRecord parameterized queries)
- XSS protection
- CSRF protection for state-changing operations
- User data isolation (all queries scoped to current_user)

### Reliability

- Error handling and graceful degradation
- Transaction rollback on errors
- Data validation at model and API levels
- Backup and recovery procedures for database
- Logging for errors and important events

### Maintainability

- RESTful API design
- Consistent code style and conventions
- Comprehensive comments and documentation
- Modular component structure
- Separation of concerns (services, controllers, models)

## Testing Strategy

### Backend Testing

- **Unit Tests**: RSpec for models, validations, associations, scopes
- **Controller Tests**: RSpec for API endpoints, authentication, authorization
- **Integration Tests**: Test complete workflows (create transaction → update budget → generate report)
- **Coverage Target**: Minimum 80% code coverage

### Frontend Testing

- **Unit Tests**: Jasmine/Karma for services, controllers, filters
- **Component Tests**: Test component rendering and user interactions
- **E2E Tests**: Protractor or similar for critical user flows (login → add transaction → view report)
- **Coverage Target**: Minimum 70% code coverage

### Test Scenarios (Priority)

1. User registration and authentication flow
2. Create, read, update, delete transactions
3. Budget creation and progress tracking
4. Recurring transaction auto-generation
5. Report generation with various filters
6. Category management and transaction reassignment
7. Savings goal contribution tracking

## Deployment Considerations

### Development Environment

- Local PostgreSQL database
- Rails server on port 3000
- AngularJS dev server on port 4200 or served via Rails
- Hot reload for frontend development

### Production Environment

- PostgreSQL database (managed service or self-hosted)
- Rails API server (Puma/Unicorn)
- Frontend static files served via CDN or web server (Nginx)
- Environment variables for sensitive configuration
- SSL/TLS certificates
- Database backups (daily automated)

### Environment Variables Required

- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY_BASE` - Rails secret key
- `JWT_SECRET` - JWT token signing secret
- `CORS_ORIGIN` - Allowed frontend origin
- `RAILS_ENV` - Environment (development/production)