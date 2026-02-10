# Pre-Deployment Checklist

Use this checklist before deploying your Personal Finance Backend to ensure everything is configured correctly.

## 📋 Pre-Deployment Setup

### Local Verification
- [ ] Application runs locally without errors
  ```bash
  bundle install
  rails db:create db:migrate
  rails s
  ```
- [ ] All tests pass locally
  ```bash
  bin/rails test
  ```
- [ ] Linting passes
  ```bash
  bin/rubocop
  ```
- [ ] Security scan passes
  ```bash
  bin/brakeman
  ```
- [ ] Code is committed to GitHub
  ```bash
  git status
  git push
  ```

### Configuration Files
- [ ] `config/master.key` exists locally (you'll need this)
- [ ] `config/database.yml` is properly configured
- [ ] `Dockerfile` builds successfully
  ```bash
  docker build -t test-build .
  ```
- [ ] `.gitignore` includes sensitive files
  - [ ] `config/master.key` ✓
  - [ ] `*.env` ✓

### Environment Variables Preparation
- [ ] Have access to `RAILS_MASTER_KEY`
  ```bash
  cat config/master.key
  ```
- [ ] Know which hosting platform you're using
- [ ] Have `.env.example` for reference

## 🚀 Deployment Checklist

### Choose Your Platform
- [ ] Render (Recommended for beginners) → [Quick Start](QUICKSTART_DEPLOYMENT.md#fastest-option-deploy-to-render)
- [ ] Railway (Best CLI experience) → [Quick Start](QUICKSTART_DEPLOYMENT.md#alternative-deploy-to-railway-cli-method)
- [ ] Fly.io (Best performance) → [Quick Start](QUICKSTART_DEPLOYMENT.md#alternative-deploy-to-flyio)
- [ ] Heroku (Paid, established) → [Full Tutorial](DEPLOYMENT_TUTORIAL.md#option-4-deploy-to-heroku)

### Platform Setup
- [ ] Account created on chosen platform
- [ ] PostgreSQL database provisioned
- [ ] Database connection URL saved

### Application Deployment
- [ ] Web service/application created
- [ ] GitHub repository connected (or CLI configured)
- [ ] Docker runtime selected
- [ ] Region chosen (close to your users)

### Environment Variables Set
Required variables:
- [ ] `RAILS_ENV=production`
- [ ] `RAILS_MASTER_KEY=<your-key>`
- [ ] `DATABASE_URL=<database-url>`
- [ ] `RAILS_SERVE_STATIC_FILES=true`
- [ ] `RAILS_LOG_TO_STDOUT=true`

Optional variables (if needed):
- [ ] `PORT` (usually auto-set)
- [ ] `RAILS_MAX_THREADS`
- [ ] `WEB_CONCURRENCY`
- [ ] `DB_POOL`

### Deployment Execution
- [ ] Initial deployment triggered
- [ ] Build completed successfully
- [ ] Container started without errors

## ✅ Post-Deployment Verification

### Database Setup
- [ ] Migrations ran successfully
  ```bash
  # Check platform-specific command
  rails db:migrate
  ```
- [ ] Database is accessible from application
- [ ] Seed data loaded (if applicable)
  ```bash
  rails db:seed
  ```

### Application Health
- [ ] Health check endpoint responds
  ```bash
  curl https://your-app-url.com/up
  # Expected: 200 OK
  ```
- [ ] Application logs show no errors
- [ ] No database connection errors in logs

### API Testing
- [ ] Test a simple GET endpoint
  ```bash
  curl https://your-app-url.com/api/endpoint
  ```
- [ ] Test authentication (if applicable)
- [ ] Test a POST request
- [ ] Verify CORS settings (if frontend exists)

### Performance & Monitoring
- [ ] Application responds within acceptable time
- [ ] Check memory usage (should be under platform limits)
- [ ] Set up monitoring/alerts (if available)
- [ ] Configure log retention

### Security Checklist
- [ ] `RAILS_MASTER_KEY` is set as environment variable (not in code)
- [ ] Database credentials are secure
- [ ] SSL/HTTPS is enabled
- [ ] Review [SECURITY.md](SECURITY.md) guidelines
- [ ] No secrets in logs

### Documentation & URLs
- [ ] Save production URL
- [ ] Document how to access logs
- [ ] Document how to run migrations
- [ ] Document how to access console/shell
- [ ] Share API documentation with team

## 🔄 Ongoing Maintenance

### Regular Tasks
- [ ] Monitor application performance
- [ ] Check error logs weekly
- [ ] Update dependencies monthly
- [ ] Backup database regularly
- [ ] Review security updates

### When Making Changes
- [ ] Test locally first
- [ ] Run tests before deploying
- [ ] Deploy during low-traffic periods
- [ ] Monitor logs after deployment
- [ ] Have rollback plan ready

## 🆘 Troubleshooting Resources

If something goes wrong:
1. Check the [Troubleshooting section](DEPLOYMENT_TUTORIAL.md#troubleshooting)
2. Review platform-specific logs
3. Verify all environment variables are set
4. Check database connectivity
5. Review recent changes

### Common Issues Quick Links
- [Build Failures](DEPLOYMENT_TUTORIAL.md#1-build-failures)
- [Database Connection Errors](DEPLOYMENT_TUTORIAL.md#2-database-connection-errors)
- [Missing Master Key](DEPLOYMENT_TUTORIAL.md#3-missing-master-key-error)
- [Application Won't Start](DEPLOYMENT_TUTORIAL.md#4-application-wont-start)

## 📚 Additional Resources

- [Quick Start Guide](QUICKSTART_DEPLOYMENT.md) - Deploy in 10 minutes
- [Full Deployment Tutorial](DEPLOYMENT_TUTORIAL.md) - Detailed instructions
- [API Documentation](API_DOCUMENTATION.md) - Test your endpoints
- [CI/CD Tutorial](CI_TUTORIAL.md) - Automated testing
- [Security Policy](SECURITY.md) - Best practices

---

**Pro Tip:** Print or save this checklist and check off items as you go. It helps ensure nothing is missed during deployment!

🎉 **Ready to deploy?** Follow the [Quick Start Guide](QUICKSTART_DEPLOYMENT.md) to get started!
