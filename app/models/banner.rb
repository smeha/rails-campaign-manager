class Banner < ApplicationRecord
	belongs_to :user

	validates :name, presence: true
	validates :text, presence: true
end
