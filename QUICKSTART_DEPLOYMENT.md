# Quick Start Deployment Guide

**⚡ Deploy in under 10 minutes!** This is a condensed version of the [full deployment tutorial](DEPLOYMENT_TUTORIAL.md).

## Fastest Option: Deploy to Render

### 1️⃣ Setup (2 minutes)
1. Go to [render.com](https://render.com) and sign up with GitHub
2. Click **New +** → **PostgreSQL** → Name: `personal-finance-db` → Click **Create**
3. Copy the **Internal Database URL** from your new database

### 2️⃣ Deploy (5 minutes)
1. Click **New +** → **Web Service**
2. Connect your GitHub repo: `hoangchung16-00/personal-finance-backend`
3. Configure:
   - **Name**: `personal-finance-api`
   - **Runtime**: Docker
   - **Plan**: Free

### 3️⃣ Environment Variables (2 minutes)
Add these in the Environment section:
```
RAILS_ENV=production
RAILS_MASTER_KEY=<get-from-config/master.key>
DATABASE_URL=<paste-internal-database-url>
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

To get your `RAILS_MASTER_KEY`:
```bash
cat config/master.key
```

### 4️⃣ Launch
Click **Create Web Service** → Wait 5 minutes for build → Done! 🎉

Your API will be live at: `https://personal-finance-api.onrender.com`

---

## Alternative: Deploy to Railway (CLI Method)

### 1️⃣ Install & Login (1 minute)
```bash
npm i -g @railway/cli
railway login
```

### 2️⃣ Initialize & Deploy (3 minutes)
```bash
railway init
railway add --plugin postgresql
railway variables set RAILS_MASTER_KEY=$(cat config/master.key)
railway variables set RAILS_ENV=production
railway variables set RAILS_SERVE_STATIC_FILES=true
railway variables set RAILS_LOG_TO_STDOUT=true
railway up
```

### 3️⃣ Setup Database (1 minute)
```bash
railway run rails db:migrate
railway domain
```

Done! 🎉

---

## Alternative: Deploy to Fly.io

### 1️⃣ Install & Login (1 minute)
```bash
curl -L https://fly.io/install.sh | sh
flyctl auth login
```

### 2️⃣ Launch & Deploy (5 minutes)
```bash
flyctl launch  # Answer prompts: choose region, yes to PostgreSQL
flyctl secrets set RAILS_MASTER_KEY=$(cat config/master.key)
flyctl secrets set RAILS_ENV=production
flyctl secrets set RAILS_SERVE_STATIC_FILES=true
flyctl secrets set RAILS_LOG_TO_STDOUT=true
flyctl deploy
```

### 3️⃣ Migrate Database (1 minute)
```bash
flyctl ssh console
rails db:migrate
exit
```

Done! 🎉 Your app is at: `https://your-app.fly.dev`

---

## Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails | Check Ruby version is 3.3.6 |
| Can't connect to DB | Verify `DATABASE_URL` is set |
| "Invalid key" error | Set `RAILS_MASTER_KEY` from `config/master.key` |
| App won't start | Check logs, ensure migrations ran |

## Test Your Deployment

```bash
# Health check
curl https://your-app-url.com/up

# Should return 200 OK
```

---

## Need More Help?

📖 See the [Full Deployment Tutorial](DEPLOYMENT_TUTORIAL.md) for:
- Detailed explanations
- All hosting options
- Advanced configuration
- Complete troubleshooting guide

## What's Next?

✅ Test your API endpoints (see [API_DOCUMENTATION.md](API_DOCUMENTATION.md))  
✅ Set up monitoring  
✅ Configure database backups  
✅ Review security best practices ([SECURITY.md](SECURITY.md))  
✅ Set up CI/CD ([CI_TUTORIAL.md](CI_TUTORIAL.md))

**Questions?** Check the [full tutorial](DEPLOYMENT_TUTORIAL.md) or create a GitHub issue.

Happy deploying! 🚀
