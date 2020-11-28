class User < ApplicationRecord
	has_many :campaigns

	EMAIL_VALDATION_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # Credit to stackoverflow

	has_secure_password
	before_save { self.email = email.downcase }
	validates :name, presence: true
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_VALDATION_FORMAT }
	validates :password, presence: true
end
