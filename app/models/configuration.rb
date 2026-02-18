# == Schema Information
#
# Table name: configurations
#
#  id         :integer         not null, primary key
#  key        :string(255)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

class Configuration < ActiveRecord::Base
  validates :key,   presence: true, uniqueness: { case_sensitive: false }
  validates :value, presence: true
end
