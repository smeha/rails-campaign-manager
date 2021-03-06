class Campaign < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :banners_id, presence: true
end
