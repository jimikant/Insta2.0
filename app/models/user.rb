class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  #For user_role
  enum role: [:user, :admin]


  has_many :subscriptions, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post, dependent: :destroy

  before_validation :normalize_email

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true,format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true


  # Scopes Ascending and Descending Order
  default_scope -> { order(created_at: :desc) }
  scope :user_asc_order, -> { reorder(created_at: :asc) }


  #For friendly_id
  extend FriendlyId
  friendly_id :username, use: :slugged

  def should_generate_new_friendly_id?
    username_changed? || super
  end


  #For sending_email_to_user
  after_create :send_welcome_email

  def send_welcome_email
    Rails.logger.info "Enqueuing welcome email for user #{self.id}"
    MailerJob.perform_async(self.id)
  end


  # For subscription_status
  def current_subscription
    subscriptions.where(active: true).first
  end


  #For creating_update_and_destroing_strip_customer_id
  after_create :create_stripe_customer
  after_update :update_stripe_customer
  after_destroy :delete_stripe_customer


  private

  #For creating_update_and_destroing_strip_customer_id
  def create_stripe_customer
    stripe_customer = Stripe::Customer.create({
      email: email,
      name: username
    })

    update(stripe_customer_id: stripe_customer.id)
  end

  def update_stripe_customer
    stripe_response = Stripe::Customer.update( stripe_customer_id,
    {
      email: email,
      name: username
    })

    puts "Stripe_customer_details: #{stripe_response}"
  end

  def delete_stripe_customer
    if stripe_customer_id.present?
      begin
        Stripe::Customer.delete(stripe_customer_id)
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error "Stripe customer deletion failed: #{e.message}"
      end
    end
  end


  # Email_normalize
  def normalize_email
    if email.present?
      self.email = email.downcase
    end
  end
end
