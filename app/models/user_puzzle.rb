class UserPuzzle < ApplicationRecord
	belongs_to :user
	belongs_to :puzzle

	serialize :playback, Array
end
