class User < ApplicationRecord
  # Associations
  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :transactions, through: :accounts

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  # API Key Authentication Methods

  # Generate a new API key for the user
  # Returns the plain API key that should be shared with the user ONCE
  # The digest is stored in the database for authentication
  def generate_api_key
    # Generate a secure random token (64 hex chars = 256 bits of entropy)
    api_key = SecureRandom.hex(32)

    # Store using bcrypt for security against database compromise
    # Note: For large user bases, consider caching or token prefixes for better lookup performance
    self.api_key_digest = BCrypt::Password.create(api_key)
    self.api_key_created_at = Time.current
    save!

    # Return the plain key for the user to store
    api_key
  end

  # Authenticate user by API key
  # Returns the user if valid, nil otherwise
  def self.authenticate_by_api_key(api_key)
    return nil if api_key.blank?

    # For better performance with many users, we could implement:
    # 1. Token prefix system (first 8 chars in separate indexed column)
    # 2. Two-tier lookup (SHA256 for lookup, bcrypt for verification)
    # 3. Caching layer
    # Current simple implementation checks each user's bcrypt hash
    User.where.not(api_key_digest: nil).find_each do |user|
      begin
        bcrypt_hash = BCrypt::Password.new(user.api_key_digest)
        return user if bcrypt_hash == api_key
      rescue BCrypt::Errors::InvalidHash
        # Skip if hash is corrupted
        next
      end
    end
    
    nil
  end

  # Check if the user has an API key
  def api_key_present?
    api_key_digest.present?
  end

  # Revoke the current API key
  def revoke_api_key
    update!(api_key_digest: nil, api_key_created_at: nil)
  end
end
