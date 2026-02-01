# API Security Notes

## CSRF Protection

The API controllers (`app/controllers/api/v1/*`) disable CSRF protection via `skip_before_action :verify_authenticity_token`. This is **intentional and safe** for the following reasons:

1. **API-Only Design**: This is a stateless REST API, not a web application with session-based cookies
2. **Token-Based Authentication**: The API uses API key authentication (Bearer tokens) rather than session cookies
3. **No Cookie-Based Sessions**: Without session cookies, there's no risk of CSRF attacks

## Authentication Implementation

✅ **API Key Authentication** is now implemented.

### How It Works

1. **Key Generation**: Each user can generate an API key using `user.generate_api_key`
2. **Secure Storage**: API keys are hashed using SHA256 before storage in the database
3. **Authentication**: Clients include the API key in the `Authorization` header as `Bearer <api_key>`
4. **Validation**: The server hashes the provided key and compares it to stored digests

### Security Features

- **Hashed Storage**: Only SHA256 hashes are stored, never plain API keys
- **Unique Index**: Database constraint ensures API key uniqueness
- **Bearer Token Format**: Industry-standard authentication header format
- **User Isolation**: All API endpoints enforce user-specific data access
- **Revocation**: API keys can be revoked using `user.revoke_api_key`

### Best Practices

**For API Users:**
- Store API keys securely (environment variables, secrets manager)
- Never commit API keys to version control
- Use HTTPS in production to protect keys in transit
- Rotate API keys periodically
- Revoke compromised keys immediately

**For Developers:**
- API keys are single-use per response - store them when generated
- Use the Rails console or admin interface to generate keys
- Monitor for suspicious authentication patterns
- Consider implementing rate limiting per API key

### Generating API Keys

```ruby
# In Rails console
user = User.find_by(email: "user@example.com")
api_key = user.generate_api_key
puts "API Key (save this): #{api_key}"
```

### Using API Keys

```bash
curl -H "Authorization: Bearer your_api_key_here" \
     http://localhost:3000/api/v1/accounts
```

## Current Security Measures

✅ Implemented:
- API key authentication with SHA256 hashing
- Input validation on all models
- Strong parameters in controllers
- Proper foreign key constraints in database
- ActiveRecord protection against SQL injection
- Positive amount validation for transactions
- User data isolation (users can only access their own data)

⚠️ To Be Implemented Before Production:
- Rate limiting per API key
- Request logging and monitoring
- API versioning headers
- HTTPS enforcement (configured in production)
- Automated API key rotation
- IP-based rate limiting
- Brute force protection

## Future Enhancements

Consider implementing:
1. **API Key Scopes**: Limit what each API key can access
2. **Multiple Keys Per User**: Allow separate keys for different applications
3. **Key Expiration**: Automatic expiration after a set period
4. **Audit Logging**: Track all API key usage
5. **Admin Dashboard**: UI for managing API keys

## CodeQL Findings

**[rb/csrf-protection-disabled]** - This is a known false positive for API-only applications. CSRF protection is not applicable to stateless, token-authenticated APIs.
