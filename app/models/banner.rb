class Banner < ApplicationRecord
  belongs_to :user
  has_many :campaigns, foreign_key: :banners_id, inverse_of: :banner, dependent: :destroy

  validates :name, presence: true
  validates :text, presence: true
end
