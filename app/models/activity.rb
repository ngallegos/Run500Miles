# == Schema Information
#
# Table name: activities
#
#  id            :integer         primary key
#  comment       :string(255)
#  user_id       :integer
#  activity_date :date
#  distance      :float
#  hours         :integer
#  minutes       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  location      :string(255)
#  activity_type :integer
#

class Activity < ActiveRecord::Base
  belongs_to :user

  validates :user_id,       presence: true
  validates :activity_date, presence: true
  validates :distance,      presence: true, numericality: { greater_than: 0.0 }
  validates :hours,         presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :minutes,       presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :activity_type, presence: true
  validates :location,      length: { maximum: 140 }
  validates :comment,       length: { maximum: 140 }
  validate :validate_non_zero_time
  validate :validate_activity_date

  default_scope { order(created_at: :desc) }

  private

    def validate_non_zero_time
      if hours == 0 && minutes == 0
        errors.add(:base, "An activity time of 0 is not allowed.")
      end
    end

    def validate_activity_date
      if !activity_date.nil? && activity_date > Date.today
        errors.add(:activity_date, "cannot be in the future")
      end
    end
end
