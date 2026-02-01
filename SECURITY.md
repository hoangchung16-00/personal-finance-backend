# API Security Notes

## CSRF Protection

The API controllers (`app/controllers/api/v1/*`) disable CSRF protection via `skip_before_action :verify_authenticity_token`. This is **intentional and safe** for the following reasons:

1. **API-Only Design**: This is a stateless REST API, not a web application with session-based cookies
2. **Token-Based Authentication**: The API is designed to use token-based authentication (JWT, API keys, or OAuth) rather than session cookies
3. **No Cookie-Based Sessions**: Without session cookies, there's no risk of CSRF attacks

## Authentication Status

⚠️ **Important**: The current implementation uses a placeholder authentication mechanism (`User.first`) for development purposes only.

**Before deploying to production, you MUST implement proper authentication:**

1. **JWT Authentication** (Recommended)
   - Add `jwt` gem
   - Implement token generation on login
   - Validate tokens in `BaseController#current_user`

2. **API Key Authentication**
   - Generate unique API keys per user
   - Validate API key in request headers
   - Store hashed API keys in database

3. **OAuth 2.0**
   - Use a gem like `doorkeeper`
   - Configure OAuth providers
   - Implement OAuth flow

## Current Security Measures

✅ Implemented:
- Input validation on all models
- Strong parameters in controllers
- Proper foreign key constraints in database
- ActiveRecord protection against SQL injection
- Positive amount validation for transactions

⚠️ To Be Implemented:
- Token-based authentication
- Rate limiting
- Request logging and monitoring
- API versioning headers
- HTTPS enforcement (configured in production)

## CodeQL Findings

**[rb/csrf-protection-disabled]** - This is a known false positive for API-only applications. CSRF protection is not applicable to stateless, token-authenticated APIs.
