# Deployment Tutorial for Personal Finance Backend

This comprehensive guide will help you deploy this Ruby on Rails API backend to various free hosting platforms.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Option 1: Deploy to Render (Recommended for Beginners)](#option-1-deploy-to-render-recommended-for-beginners)
- [Option 2: Deploy to Railway](#option-2-deploy-to-railway)
- [Option 3: Deploy to Fly.io](#option-3-deploy-to-flyio)
- [Option 4: Deploy to Heroku](#option-4-deploy-to-heroku)
- [Environment Variables Configuration](#environment-variables-configuration)
- [Post-Deployment Setup](#post-deployment-setup)
- [Troubleshooting](#troubleshooting)

## Overview

This Personal Finance Backend is a Ruby on Rails 8.0 API application with:
- **Language**: Ruby 3.3.6
- **Framework**: Rails 8.0.2
- **Database**: PostgreSQL
- **Web Server**: Puma with Thruster
- **Containerization**: Docker support included

## Prerequisites

Before deploying, ensure you have:
1. A GitHub account with this repository pushed
2. Basic understanding of environment variables
3. A free account on your chosen hosting platform

## Option 1: Deploy to Render (Recommended for Beginners)

**Why Render?** Free tier includes PostgreSQL database, automatic deployments, and easy setup.

### Step 1: Create a Render Account
1. Go to [render.com](https://render.com)
2. Sign up with your GitHub account
3. Authorize Render to access your repositories

### Step 2: Create a PostgreSQL Database
1. Click "New +" and select "PostgreSQL"
2. Configure your database:
   - **Name**: `personal-finance-db`
   - **Database**: `personal_finance_production`
   - **User**: (auto-generated)
   - **Region**: Choose closest to you
   - **Plan**: Free
3. Click "Create Database"
4. **Save the Internal Database URL** - you'll need this later

### Step 3: Create a Web Service
1. Click "New +" and select "Web Service"
2. Connect your GitHub repository: `hoangchung16-00/personal-finance-backend`
3. Configure the service:
   - **Name**: `personal-finance-api`
   - **Region**: Same as your database
   - **Branch**: `main`
   - **Runtime**: `Docker`
   - **Plan**: Free

### Step 4: Configure Environment Variables
In the "Environment" section, add:

```
RAILS_ENV=production
RAILS_MASTER_KEY=<your-master-key>
DATABASE_URL=<internal-database-url-from-step-2>
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

**To get your RAILS_MASTER_KEY:**
```bash
cat config/master.key
```

### Step 5: Deploy
1. Click "Create Web Service"
2. Render will automatically:
   - Build your Docker image
   - Run database migrations
   - Start your server
3. Your API will be available at: `https://personal-finance-api.onrender.com`

### Step 6: Run Database Migrations (if needed)
If migrations don't run automatically:
1. Go to your service dashboard
2. Click "Shell" tab
3. Run: `rails db:migrate`

---

## Option 2: Deploy to Railway

**Why Railway?** Simple CLI, good free tier, easy database provisioning.

### Step 1: Install Railway CLI
```bash
# Install Railway CLI
npm i -g @railway/cli

# Or with Homebrew (macOS)
brew install railway
```

### Step 2: Login and Initialize
```bash
# Login to Railway
railway login

# Initialize a new project
railway init
```

### Step 3: Add PostgreSQL Database
```bash
railway add --plugin postgresql
```

### Step 4: Set Environment Variables
```bash
# Set Rails master key
railway variables set RAILS_MASTER_KEY=$(cat config/master.key)

# Set other required variables
railway variables set RAILS_ENV=production
railway variables set RAILS_SERVE_STATIC_FILES=true
railway variables set RAILS_LOG_TO_STDOUT=true
```

Railway automatically sets `DATABASE_URL` when you add PostgreSQL.

### Step 5: Deploy
```bash
# Deploy using Docker
railway up
```

### Step 6: Run Migrations
```bash
railway run rails db:migrate
```

### Step 7: Access Your App
```bash
# Generate a public URL
railway domain
```

Your API will be accessible at the generated URL.

---

## Option 3: Deploy to Fly.io

**Why Fly.io?** Great performance, edge computing, generous free tier.

### Step 1: Install Fly CLI
```bash
# macOS/Linux
curl -L https://fly.io/install.sh | sh

# Windows (PowerShell)
iwr https://fly.io/install.ps1 -useb | iex
```

### Step 2: Login
```bash
flyctl auth login
```

### Step 3: Launch Your App
```bash
# This will create a fly.toml configuration
flyctl launch

# Choose options:
# - App name: personal-finance-api (or your choice)
# - Region: Choose closest to you
# - PostgreSQL: Yes
# - Redis: No (not needed)
```

### Step 4: Set Environment Variables
```bash
# Set Rails master key
flyctl secrets set RAILS_MASTER_KEY=$(cat config/master.key)

# Set other variables
flyctl secrets set RAILS_ENV=production
flyctl secrets set RAILS_SERVE_STATIC_FILES=true
flyctl secrets set RAILS_LOG_TO_STDOUT=true
```

### Step 5: Deploy
```bash
# Deploy your application
flyctl deploy
```

### Step 6: Run Migrations
```bash
flyctl ssh console
rails db:migrate
exit
```

### Step 7: Access Your App
Your app will be available at: `https://personal-finance-api.fly.dev`

---

## Option 4: Deploy to Heroku

**Why Heroku?** Well-documented, reliable, established platform.

**Note:** Heroku ended its free tier in November 2022, but offers a low-cost Eco plan ($5/month).

### Step 1: Install Heroku CLI
```bash
# macOS
brew tap heroku/brew && brew install heroku

# Windows
# Download from: https://devcenter.heroku.com/articles/heroku-cli

# Linux
curl https://cli-assets.heroku.com/install.sh | sh
```

### Step 2: Login
```bash
heroku login
```

### Step 3: Create a New App
```bash
# Create app
heroku create personal-finance-api

# Add PostgreSQL
heroku addons:create heroku-postgresql:mini
```

### Step 4: Set Buildpack
```bash
# Use Docker deployment
heroku stack:set container
```

### Step 5: Set Environment Variables
```bash
# Set Rails master key
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)

# Set other variables
heroku config:set RAILS_ENV=production
heroku config:set RAILS_SERVE_STATIC_FILES=true
heroku config:set RAILS_LOG_TO_STDOUT=true
```

### Step 6: Deploy
```bash
# Add Heroku remote (if not added)
heroku git:remote -a personal-finance-api

# Push to Heroku
git push heroku main
```

### Step 7: Run Migrations
```bash
heroku run rails db:migrate
```

### Step 8: Open Your App
```bash
heroku open
```

---

## Environment Variables Configuration

### Quick Reference

See [.env.example](.env.example) for a complete list of environment variables with descriptions and platform-specific notes.

### Required Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `RAILS_ENV` | Rails environment | `production` |
| `RAILS_MASTER_KEY` | Encryption key for credentials | From `config/master.key` |
| `DATABASE_URL` | PostgreSQL connection URL | Auto-set by most platforms |
| `RAILS_SERVE_STATIC_FILES` | Serve static assets | `true` |
| `RAILS_LOG_TO_STDOUT` | Enable stdout logging | `true` |

### Optional Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `3000` or platform default |
| `RAILS_MAX_THREADS` | Max Puma threads | `5` |
| `WEB_CONCURRENCY` | Puma worker count | `2` |
| `DB_POOL` | Database connection pool | Same as `RAILS_MAX_THREADS` |

### Getting Your Rails Master Key

The `RAILS_MASTER_KEY` is located in `config/master.key`. To view it:

```bash
cat config/master.key
```

**⚠️ Security Warning:** Never commit `config/master.key` to Git! It's already in `.gitignore`.

---

## Post-Deployment Setup

### 1. Verify Your Deployment

Test that your API is running:

```bash
# Replace with your actual URL
curl https://your-app-url.com/up
```

You should receive a successful response.

### 2. Create Initial Admin User (if applicable)

If your app has seed data or requires an initial user:

```bash
# For Render: Use the Shell tab in dashboard
rails db:seed

# For Railway
railway run rails db:seed

# For Fly.io
flyctl ssh console -C "rails db:seed"

# For Heroku
heroku run rails db:seed
```

### 3. Test Your API Endpoints

Use the [API Documentation](API_DOCUMENTATION.md) to test your endpoints:

```bash
# Health check
curl https://your-app-url.com/up

# Test other endpoints as documented
curl -X POST https://your-app-url.com/api/users \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "test@example.com", "password": "password123"}}'
```

### 4. Monitor Your Application

Each platform provides monitoring tools:
- **Render**: Logs tab in dashboard
- **Railway**: Observability tab
- **Fly.io**: `flyctl logs`
- **Heroku**: `heroku logs --tail`

### 5. Set Up Custom Domain (Optional)

Most platforms allow custom domains on paid plans:
1. Add your domain in the platform dashboard
2. Update your DNS records as instructed
3. Enable SSL/TLS (usually automatic)

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Build Failures

**Issue:** Docker build fails

**Solutions:**
- Ensure Ruby version matches `.ruby-version` (3.3.6)
- Check that all dependencies in `Gemfile` are compatible
- Review build logs for specific error messages

```bash
# Test build locally
docker build -t personal-finance-test .
```

#### 2. Database Connection Errors

**Issue:** `PG::ConnectionBad` or `could not connect to server`

**Solutions:**
- Verify `DATABASE_URL` is set correctly
- Ensure database service is running
- Check that database exists and migrations have run

```bash
# Run migrations
rails db:migrate

# Create database if needed
rails db:create db:migrate
```

#### 3. Missing Master Key Error

**Issue:** `ActiveSupport::MessageEncryptor::InvalidMessage`

**Solutions:**
- Ensure `RAILS_MASTER_KEY` environment variable is set
- Verify the key matches your local `config/master.key`

```bash
# Check if master key exists locally
cat config/master.key
```

#### 4. Application Won't Start

**Issue:** Server crashes on startup

**Solutions:**
- Check logs for specific error messages
- Verify all environment variables are set
- Ensure database migrations have run successfully

```bash
# Platform-specific log commands
# Render: Use web dashboard Logs tab
railway logs
flyctl logs
heroku logs --tail
```

#### 5. SSL/HTTPS Issues

**Issue:** Mixed content or SSL errors

**Solutions:**
- Ensure `RAILS_FORCE_SSL=true` for production (if needed)
- Check platform SSL/TLS configuration
- Verify custom domain DNS if applicable

#### 6. Memory or Performance Issues

**Issue:** App slow or running out of memory

**Solutions:**
- Reduce `WEB_CONCURRENCY` if memory-constrained
- Adjust `RAILS_MAX_THREADS` based on workload
- Consider upgrading to a paid tier

```bash
# Set lower concurrency
WEB_CONCURRENCY=1
RAILS_MAX_THREADS=3
```

#### 7. Port Binding Errors

**Issue:** `Cannot bind to port` errors

**Solutions:**
- Most platforms auto-set `PORT` environment variable
- Ensure your app reads `PORT` from environment:
  ```ruby
  # config/puma.rb already handles this
  port ENV.fetch("PORT") { 3000 }
  ```

### Getting Help

If you encounter issues:

1. **Check Platform Documentation:**
   - [Render Docs](https://render.com/docs)
   - [Railway Docs](https://docs.railway.app)
   - [Fly.io Docs](https://fly.io/docs)
   - [Heroku Docs](https://devcenter.heroku.com)

2. **Review Application Logs:**
   - Look for error messages and stack traces
   - Check for missing environment variables

3. **Test Locally:**
   ```bash
   # Run with production settings locally
   RAILS_ENV=production rails db:migrate
   RAILS_ENV=production rails s
   ```

4. **Community Support:**
   - [Rails Forum](https://discuss.rubyonrails.org)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/ruby-on-rails)
   - Platform-specific community forums

---

## Platform Comparison

| Feature | Render | Railway | Fly.io | Heroku |
|---------|--------|---------|--------|--------|
| **Free Tier** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No ($5/mo min) |
| **Database Included** | ✅ PostgreSQL | ✅ PostgreSQL | ✅ PostgreSQL | ⚠️ Add-on required |
| **Auto-Deploy** | ✅ GitHub | ✅ GitHub | ✅ Manual/GitHub Actions | ✅ Git push |
| **Ease of Setup** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Performance** | Good | Good | Excellent | Excellent |
| **Free DB Size** | 1 GB | 1 GB | 3 GB | N/A |
| **Free Hours** | 750/mo | $5 credit | Varies | N/A |
| **Docker Support** | ✅ Native | ✅ Native | ✅ Native | ✅ Native |
| **Custom Domains** | ✅ Free | 💰 Paid | ✅ Free | 💰 Paid |

### Recommendation

**For beginners:** Start with **Render**
- Easiest setup process
- Clear documentation
- Free PostgreSQL included
- Great for learning deployment

**For developers:** Consider **Railway** or **Fly.io**
- Railway: Best CLI experience
- Fly.io: Best performance and features

**For production:** Consider **Heroku** or **Fly.io**
- Battle-tested infrastructure
- Better support and reliability
- Worth the cost for critical applications

---

## Next Steps

After successful deployment:

1. ✅ Test all API endpoints (see [API_DOCUMENTATION.md](API_DOCUMENTATION.md))
2. ✅ Set up monitoring and alerting
3. ✅ Configure backups for your database
4. ✅ Review [SECURITY.md](SECURITY.md) for security best practices
5. ✅ Set up CI/CD (see [CI_TUTORIAL.md](CI_TUTORIAL.md))
6. ✅ Consider a custom domain for production use
7. ✅ Set up error tracking (e.g., Sentry, Rollbar)

---

## Additional Resources

- [Official API Documentation](API_DOCUMENTATION.md)
- [CI/CD Tutorial](CI_TUTORIAL.md)
- [Implementation Guide](IMPLEMENTATION.md)
- [Security Policy](SECURITY.md)
- [Rails Deployment Guide](https://guides.rubyonrails.org/deploying.html)
- [Docker Documentation](https://docs.docker.com)

---

## Support

If you found this guide helpful, please ⭐ star the repository!

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review existing GitHub issues
3. Create a new issue with details about your problem

Happy deploying! 🚀
