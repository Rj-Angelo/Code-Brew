class Forum < ApplicationRecord
	belongs_to :user
	belongs_to :puzzle

	validates :content, presence: true, length: { in: 4..255 }
end
