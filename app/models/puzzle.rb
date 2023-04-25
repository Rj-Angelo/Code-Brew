class Puzzle < ApplicationRecord
	belongs_to :user

	has_many :user_puzzles, dependent: :destroy
	has_many :users, through: :user_puzzles
	has_many :forums

	serialize :test_cases, Array
	serialize :expected_outputs, Array

	validates :title, presence: true
	validates :difficulty, presence: true
	validates :description, presence: true
	validates :function, presence: true
	validates :test_cases, presence: true
	validates :expected_outputs, presence: true
end
