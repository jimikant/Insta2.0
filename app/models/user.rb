# frozen_string_literal: true

class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # For user_role
  enum role: { user: 0, admin: 1 }

  has_many :subscriptions, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post, dependent: :destroy

  before_validation :normalize_email

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, confirmation: true, if: -> { password.present? }
  validates :password_confirmation, presence: true, if: -> { password.present? }

  # Override password_required? to conditionally skip password validation
  def password_required?
    return false if skip_password_validation?
    super
  end

  # Scopes Ascending and Descending Order
  default_scope -> { order(created_at: :desc) }
  scope :user_asc_order, -> { reorder(created_at: :asc) }

  # For friendly_id
  extend FriendlyId
  friendly_id :username, use: :slugged

  def should_generate_new_friendly_id?
    username_changed? || super
  end

  # For sending_email_to_user
  after_create :send_welcome_email, unless: :skip_welcome_email?

  def send_welcome_email
    Rails.logger.info "Enqueuing welcome email for user #{id}"
    MailerJob.perform_async(id)
  end

  # For skipping welcome email when the user is created by an admin
  def skip_welcome_email?
    @skip_password_validation.present? && @skip_password_validation
  end

  # For subscription_status
  def current_subscription
    subscriptions.where(active: true).first
  end

  # For creating_update_and_destroing_strip_customer_id
  after_create :create_stripe_customer
  after_update :update_stripe_customer
  after_destroy :delete_stripe_customer

  # Generate password reset token
  def generate_reset_password_token!
    token = SecureRandom.hex(10)
    update(reset_password_token: token, reset_password_sent_at: Time.current)
  end

  # Check if password reset token has expired
  def reset_password_token_expired?
    return true if reset_password_sent_at.nil?
    reset_password_sent_at < 2.hours.ago
  end

  # Clear the reset password token after successful reset
  def clear_reset_password_token!
    update(reset_password_token: nil, reset_password_sent_at: nil)
  end

  private

  # This flag is used to determine whether to skip password validation
  def skip_password_validation?
    @skip_password_validation
  end

  # For creating, updating, and destroying Stripe customer ID
  def create_stripe_customer
    stripe_customer = Stripe::Customer.create({
                                                email: email,
                                                name: username
                                              })

    update(stripe_customer_id: stripe_customer.id)
  end

  def update_stripe_customer
    stripe_response = Stripe::Customer.update(stripe_customer_id,
                                              {
                                                email: email,
                                                name: username
                                              })

    Rails.logger.debug { "Stripe customer details: #{stripe_response}" }
  end

  def delete_stripe_customer
    return if stripe_customer_id.blank?

    begin
      Stripe::Customer.delete(stripe_customer_id)
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Stripe customer deletion failed: #{e.message}"
    end
  end

  # Email normalization
  def normalize_email
    return if email.blank?

    self.email = email.downcase
  end
end
