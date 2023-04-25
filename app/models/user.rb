class User < ApplicationRecord
  	has_secure_password

	has_many :puzzles, dependent: :destroy
	has_many :user_puzzles, dependent: :destroy
	
	before_validation :downcase_email

	validates :email, presence:true, on: :login

	validates :username, presence: true, length: { in: 4..45 }, on: [:create, :update]
	validates :email, presence: true, uniqueness: true, length: { in: 5..45 }, email: true, on: [:create, :update]
	validates :password, presence: true, comparison: { equal_to: :password_confirmation }, length: { in: 4..45 }, on: [:create, :update]
	validates :password_confirmation, presence: true, length: { in: 4..45 }, on: [:create, :update]

	def downcase_email
		self.email.downcase! if email.present?
	end
end
