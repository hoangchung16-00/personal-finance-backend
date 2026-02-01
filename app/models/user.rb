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
    # Generate a secure random token
    api_key = SecureRandom.hex(32)

    # Store the hashed version
    self.api_key_digest = Digest::SHA256.hexdigest(api_key)
    self.api_key_created_at = Time.current
    save!

    # Return the plain key for the user to store
    api_key
  end

  # Authenticate user by API key
  # Returns the user if valid, nil otherwise
  def self.authenticate_by_api_key(api_key)
    return nil if api_key.blank?

    # Hash the provided key and find user
    api_key_digest = Digest::SHA256.hexdigest(api_key)
    find_by(api_key_digest: api_key_digest)
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
