class Message < ApplicationRecord
	enum content_type: [:normal, :participate, :unparticipate]
	belongs_to :channel
	belongs_to :user
	validates :content, presence: true
	after_create_commit {MessageBroadcastJob.perform_later self}

	scope :grouped_by_date, -> { order(created_at: :desc).group_by{|u| u.created_at.strftime('%Y/%m/%d')} }
end
