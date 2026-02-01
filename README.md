# personal-finance-backend

Rails API for the Personal Finance Management System.

## Documentation
- [CI Tutorial](CI_TUTORIAL.md) - Complete guide to running unit tests with GitHub Actions
- [API Documentation](API_DOCUMENTATION.md)
- [Implementation Guide](IMPLEMENTATION.md)
- [Security Policy](SECURITY.md)

## Prerequisites
- Ruby, Rails
- PostgreSQL
- GitHub CLI (gh) installed and authenticated

## Run locally
- bundle install
- configure config/database.yml or set DATABASE_URL
- rails db:create db:migrate
- rails s -p 3000

## Testing
- Run all tests: `bin/rails test`
- Run specific test: `bin/rails test test/models/user_test.rb`
- Run linting: `bin/rubocop`
- Run security scan: `bin/brakeman`

See [CI_TUTORIAL.md](CI_TUTORIAL.md) for comprehensive testing and CI documentation.
