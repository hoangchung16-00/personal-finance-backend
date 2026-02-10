# personal-finance-backend

Rails API for the Personal Finance Management System.

## Documentation
- [Quick Start Deployment](QUICKSTART_DEPLOYMENT.md) - Deploy in under 10 minutes! ⚡
- [Deployment Tutorial](DEPLOYMENT_TUTORIAL.md) - Step-by-step guide to deploy on free hosting platforms
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

## Deployment
**Quick start:** See [QUICKSTART_DEPLOYMENT.md](QUICKSTART_DEPLOYMENT.md) to deploy in under 10 minutes.

For detailed deployment instructions on free hosting platforms (Render, Railway, Fly.io, Heroku), see the [Deployment Tutorial](DEPLOYMENT_TUTORIAL.md).

## Testing
- Run all tests: `bin/rails test`
- Run specific test: `bin/rails test test/models/user_test.rb`
- Run linting: `bin/rubocop`
- Run security scan: `bin/brakeman`

See [CI_TUTORIAL.md](CI_TUTORIAL.md) for comprehensive testing and CI documentation.
