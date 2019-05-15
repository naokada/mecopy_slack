class Channel < ApplicationRecord
	enum channel_type: [:public_ch, :private_ch]
	has_many :messages, dependent: :delete_all
	has_many :channel_users, dependent: :delete_all
	has_many :users, through: :channel_users
	validates :name, presence: true

	# 他のモデルを一括で更新、保存できるようにする
	accepts_nested_attributes_for :channel_users

	scope :joined, ->(user_id) do
		sql = "EXISTS (SELECT * FROM `channel_users` WHERE `channel_users`.`channel_id` = `channels`.`id` AND `channel_users`.`user_id` = ?)"
		where(sql, user_id)
	end
	scope :unjoined, ->(user_id) do
		sql = "EXISTS (SELECT * FROM `channel_users` WHERE `channel_users`.`channel_id` = `channels`.`id` AND `channel_users`.`user_id` = ?)"
		where.not(sql, user_id)
	end
end
