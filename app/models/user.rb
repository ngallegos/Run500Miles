# == Schema Information
#
# Table name: users
#
#  id                 :integer         primary key
#  email              :string(255)
#  created_at         :timestamp
#  updated_at         :timestamp
#  fname              :string(255)
#  lname              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  user_type          :string(255)     default("2")
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password, :secret_word

  has_many :activities, dependent: :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :fname, presence: true, length: { maximum: 50 }
  validates :lname, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    format: { with: email_regex },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       confirmation: true,
                       length: { within: 6..40 }

  validate :secret_word_okay, on: :create

  before_save :encrypt_password

  def has_password?(submitted_password)
    stored = encrypted_password
    if stored&.start_with?('$2a$', '$2b$')
      BCrypt::Password.new(stored) == submitted_password
    else
      stored == legacy_hash(submitted_password)
    end
  end

  def total_miles(timespan)
    case timespan
    when "year"
      activities.sum(:distance)
    when "week"
      activities.where('activity_date >= ?', Date.today - Date.today.wday).sum(:distance)
    end
  end

  def can_view_user?(other_user)
    return true if admin?
    return false if user_type.nil? || other_user.user_type.nil?

    self_types  = user_type.split('|')
    other_types = other_user.user_type.split('|')
    other_types.any? { |t| self_types.include?(t) }
  end

  def total_time(timespan)
    week_start = Date.today - Date.today.wday
    case timespan
    when "year"
      total_hours   = activities.sum(:hours)
      total_minutes = activities.sum(:minutes)
    when "week"
      total_hours   = activities.where('activity_date >= ?', week_start).sum(:hours)
      total_minutes = activities.where('activity_date >= ?', week_start).sum(:minutes)
    end
    total_hours.to_f + (total_minutes.to_f / 60)
  end

  def miles_left(timespan)
    total = timespan == "year" ? 500 : 10
    format("%0.2f", [total - total_miles(timespan), 0].max).to_f
  end

  def self.leaders(timespan)
    users = User.all.to_a
    conditions = timespan == "week" ? { 'activity_date >= ?' => Date.today - Date.today.wday } : {}
    users.sort! do |u1, u2|
      if conditions.empty?
        u2.activities.sum(:distance) <=> u1.activities.sum(:distance)
      else
        u2.activities.where('activity_date >= ?', Date.today - Date.today.wday).sum(:distance) <=>
        u1.activities.where('activity_date >= ?', Date.today - Date.today.wday).sum(:distance)
      end
    end
  end

  def self.authenticate(email, submitted_password)
    user = User.where("LOWER(email) = ?", email.downcase).first
    return nil unless user&.has_password?(submitted_password)

    # Upgrade legacy SHA2 passwords to bcrypt transparently on login
    if user.encrypted_password && !user.encrypted_password.start_with?('$2a$', '$2b$')
      user.update_column(:encrypted_password, BCrypt::Password.create(submitted_password))
    end

    user
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by(id: id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def feed
    if user_type.nil?
      Activity.where(user_id: id)
    else
      viewable_ids = User.all.select { |u| can_view_user?(u) }.map(&:id)
      Activity.where(user_id: viewable_ids)
    end
  end

  private

    def secret_word_okay
      if secret_word.blank?
        errors.add(:secret_word, "cannot be empty.")
        return
      end
      config = Configuration.find_by(key: 'secret-word')
      errors.add(:secret_word, "is not correct") if config.nil? || secret_word != config.value
    end

    def encrypt_password
      return if password.blank?
      self.salt ||= make_salt
      self.encrypted_password = BCrypt::Password.create(password)
    end

    def make_salt
      BCrypt::Engine.generate_salt
    end

    # Legacy SHA2 verification for accounts created before the bcrypt migration
    def legacy_hash(submitted_password)
      Digest::SHA2.hexdigest("#{salt}--#{submitted_password}")
    end
end
