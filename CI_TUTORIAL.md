# CI Tutorial: Running Unit Tests with GitHub Actions

This tutorial explains how to set up and use Continuous Integration (CI) to automatically run unit tests on your repository.

## Table of Contents
- [Overview](#overview)
- [What is CI?](#what-is-ci)
- [Your Current CI Setup](#your-current-ci-setup)
- [Running Tests Locally](#running-tests-locally)
- [Understanding the CI Workflow](#understanding-the-ci-workflow)
- [Viewing CI Results](#viewing-ci-results)
- [Customizing Your CI Pipeline](#customizing-your-ci-pipeline)
- [Troubleshooting](#troubleshooting)

## Overview

Your repository already has a fully functional CI pipeline configured! This pipeline automatically runs three important checks whenever you push code or create a pull request:

1. **Security Scan** - Checks for common Rails security vulnerabilities
2. **Code Linting** - Ensures consistent code style
3. **Unit Tests** - Runs your full test suite

## What is CI?

Continuous Integration (CI) is a development practice where developers integrate code into a shared repository frequently, and each integration is automatically verified by running tests. This helps:

- **Catch bugs early** - Tests run automatically on every change
- **Maintain code quality** - Ensures all tests pass before merging
- **Prevent breaking changes** - Alerts you if new code breaks existing functionality
- **Increase confidence** - Know that your code works across different environments

## Your Current CI Setup

Your repository uses **GitHub Actions** for CI, which is free for public repositories. The configuration is located at:

```
.github/workflows/ci.yml
```

### What Triggers CI?

The CI pipeline runs automatically on:
- **Pull Requests** - Every time you create or update a PR
- **Pushes to main branch** - When code is merged or pushed directly to main

## Running Tests Locally

Before pushing your code, you should run tests locally to catch issues early.

### Prerequisites

1. **Install Dependencies**:
   ```bash
   bundle install
   ```

2. **Set up Database**:
   ```bash
   rails db:create db:migrate
   rails db:test:prepare
   ```

### Running Tests

**Run all tests:**
```bash
bin/rails test
```

**Run a specific test file:**
```bash
bin/rails test test/models/user_test.rb
```

**Run a specific test:**
```bash
bin/rails test test/models/user_test.rb:10
```
(where `:10` is the line number of the test)

**Run tests for a specific directory:**
```bash
bin/rails test test/models/
bin/rails test test/controllers/
```

### Running Other CI Checks Locally

**Security scan (Brakeman):**
```bash
bin/brakeman --no-pager
```

**Code linting (RuboCop):**
```bash
bin/rubocop
```

**Auto-fix linting issues:**
```bash
bin/rubocop -a
```

## Understanding the CI Workflow

Let's break down your `.github/workflows/ci.yml` file:

### 1. Security Scan Job (`scan_ruby`)

```yaml
scan_ruby:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: .ruby-version
        bundler-cache: true
    - name: Scan for vulnerabilities
      run: bin/brakeman --no-pager
```

**What it does:**
- Checks out your code
- Installs Ruby and dependencies (with caching for speed)
- Runs Brakeman to detect security vulnerabilities in Rails code

### 2. Lint Job (`lint`)

```yaml
lint:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v4
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: .ruby-version
        bundler-cache: true
    - name: Lint code
      run: bin/rubocop -f github
```

**What it does:**
- Checks code style and consistency using RuboCop
- Uses GitHub format for better integration with PR comments

### 3. Test Job (`test`)

```yaml
test:
  runs-on: ubuntu-latest
  services:
    postgres:
      image: postgres
      env:
        POSTGRES_USER: postgres
        POSTGRES_PASSWORD: postgres
      ports:
        - 5432:5432
      options: --health-cmd="pg_isready" --health-interval=10s
  steps:
    - name: Install packages
      run: sudo apt-get update && sudo apt-get install -y build-essential git libpq-dev
    - name: Checkout code
      uses: actions/checkout@v4
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: .ruby-version
        bundler-cache: true
    - name: Run tests
      env:
        RAILS_ENV: test
        DATABASE_URL: postgres://postgres:postgres@localhost:5432
      run: bin/rails db:test:prepare test
```

**What it does:**
- Starts a PostgreSQL database service (required for tests)
- Installs system dependencies
- Checks out your code
- Installs Ruby and gems (with caching)
- Prepares the test database
- Runs your entire test suite

**Key features:**
- Uses database service containers for testing
- Sets proper environment variables
- Runs health checks to ensure database is ready

## Viewing CI Results

### On Pull Requests

1. Create or open a Pull Request on GitHub
2. Scroll down to see the "Checks" section
3. You'll see three checks:
   - ✅ scan_ruby - Security scan
   - ✅ lint - Code style check
   - ✅ test - Unit tests

### On the Actions Tab

1. Go to your repository on GitHub
2. Click the "Actions" tab
3. You'll see a list of all CI runs
4. Click on any run to see detailed logs
5. Click on individual jobs to see step-by-step execution

### Understanding Check Statuses

- ✅ **Green checkmark** - All checks passed
- ❌ **Red X** - One or more checks failed
- 🟡 **Yellow circle** - Checks are currently running
- ⚪ **Gray circle** - Checks are queued

## Customizing Your CI Pipeline

### Adding New Test Commands

To add additional test commands, edit `.github/workflows/ci.yml` and add steps to the test job:

```yaml
- name: Run system tests
  run: bin/rails test:system

- name: Check test coverage
  run: bin/rails test COVERAGE=true
```

### Adding Environment Variables

Add environment variables to the test job's `env` section:

```yaml
env:
  RAILS_ENV: test
  DATABASE_URL: postgres://postgres:postgres@localhost:5432
  MY_CUSTOM_VAR: value
```

### Running Tests in Parallel

Your tests already run in parallel (configured in `test/test_helper.rb`). To adjust the number of workers:

```ruby
# test/test_helper.rb
parallelize(workers: 4) # Fixed number of workers
# or
parallelize(workers: :number_of_processors) # Use all available CPUs
```

### Adding Additional Services

To add services like Redis or Elasticsearch, add them to the `services` section:

```yaml
services:
  postgres:
    # ... existing postgres config ...
  
  redis:
    image: redis
    ports:
      - 6379:6379
    options: --health-cmd "redis-cli ping" --health-interval 10s
```

### Caching Dependencies

Your CI already uses caching for Ruby gems via `bundler-cache: true`. This speeds up subsequent runs significantly.

## Troubleshooting

### Tests Pass Locally But Fail in CI

**Common causes:**
1. **Database differences** - Make sure test fixtures are committed
2. **Environment variables** - Check if tests depend on env vars not set in CI
3. **Time zones** - CI runs in UTC; ensure tests don't depend on specific time zones
4. **File paths** - Use Rails path helpers instead of absolute paths

**Solution:**
```bash
# Run tests with CI-like environment locally
RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432 bin/rails test
```

### CI is Slow

**Speed improvements:**
1. **Use caching** - Already enabled via `bundler-cache: true`
2. **Reduce test data** - Use minimal fixtures
3. **Parallel testing** - Already enabled in `test_helper.rb`
4. **Split jobs** - Consider splitting slow tests into separate jobs

### Viewing Detailed Logs

1. Go to the Actions tab on GitHub
2. Click on the failed workflow run
3. Click on the failed job
4. Expand the failed step to see full output
5. Download logs using the "Download log archive" button

### Debugging Failed Tests

**In CI logs, look for:**
```
# Test failures will show:
1) Error:
UsersControllerTest#test_should_create_user:
ActiveRecord::RecordInvalid: Validation failed: Email has already been taken
```

**To fix:**
1. Find the test file mentioned in the error
2. Run that specific test locally
3. Fix the issue
4. Commit and push

### Common RuboCop Issues

**Auto-fix most issues:**
```bash
bin/rubocop -a
```

**Ignore specific cops if needed:**
```ruby
# rubocop:disable Rails/SkipsModelValidations
User.update_all(active: true)
# rubocop:enable Rails/SkipsModelValidations
```

### Brakeman False Positives

If Brakeman reports a false positive, you can:

1. **Add a confidence filter:**
   ```bash
   bin/brakeman --no-pager --confidence-level 2
   ```

2. **Ignore specific warnings:**
   Create `config/brakeman.ignore` file and follow the prompts when running Brakeman.

## Best Practices

### 1. Write Tests First
- Follow Test-Driven Development (TDD)
- Write tests before or alongside your code
- Ensure all new features have test coverage

### 2. Keep Tests Fast
- Use fixtures or factories efficiently
- Mock external services
- Test one thing per test case

### 3. Monitor CI Status
- Don't merge PRs with failing tests
- Fix broken tests immediately
- Keep the main branch green (all tests passing)

### 4. Review CI Logs
- Check logs even when tests pass
- Look for deprecation warnings
- Watch for performance issues

### 5. Update Dependencies Regularly
- Keep Ruby and gems up to date
- Use Dependabot (already configured in `.github/dependabot.yml`)
- Test updates in CI before merging

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Rails Testing Guide](https://guides.rubyonrails.org/testing.html)
- [RuboCop Documentation](https://docs.rubocop.org/)
- [Brakeman Security Scanner](https://brakemanscanner.org/)
- [Minitest Documentation](https://github.com/minitest/minitest)

## Next Steps

1. ✅ Your CI is already set up and running!
2. Try making a small code change and create a PR to see CI in action
3. Experiment with running tests locally
4. Review the existing test files in the `test/` directory
5. Write tests for any new features you add

## Summary

Your repository has a professional CI setup that:
- ✅ Automatically runs on every PR and push
- ✅ Tests your code in a clean environment
- ✅ Checks for security vulnerabilities
- ✅ Enforces code style consistency
- ✅ Uses caching for fast execution
- ✅ Provides detailed logs for debugging

You're already following best practices for modern Rails development! 🎉
