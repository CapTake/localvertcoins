class User < ApplicationRecord

  RESTRICTED_USERNAMES = YAML.load_file(
    Rails.root.join('config', 'restricted_usernames.yml')
  ).freeze
  has_many :trade_requests
  has_many :trade_request_offers, through: :trade_requests, source: :offers
  has_many :offers
  has_many :incoming_reviews, class_name: 'Review', foreign_key: 'reviewed_user_id'

  # Include default devise modules. Others available are:
  #  :lockable,
  #  :timeoutable,
  #  :validatable,
  #  :omniauthable
  devise \
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :confirmable,
    :trackable

  attr_encrypted :email, key: Settings.attr_encrypted.key

  validates \
    :username,
    uniqueness: true
  validates \
    :email,
    :encrypted_email_iv,
    :username,
    presence: true
  validates \
    :password,
    :password_confirmation,
    presence: true,
    on: :create
  validates_format_of :username, with: /\A[a-zA-Z0-9]+\z/
  validates_acceptance_of :terms_and_conditions
  validates_confirmation_of :password, if: "changed.include?('encrypted_password')"
  validates :currency, inclusion: { in: ExchangeRateService::CURRENCIES }
  validates :username, exclusion: { in: RESTRICTED_USERNAMES }

  def admin?
    confirmed? and email == Settings.admin.email
  end

  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.find_by_username(login)
    where(["lower(username) = :value", { :value => login.downcase }]).first
  end

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string           not null
#  encrypted_email        :string           not null
#  encrypted_email_iv     :string           not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  currency               :string           not null
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
