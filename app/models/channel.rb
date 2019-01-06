class Channel < ApplicationRecord
    has_many :messages
    has_many :users, through: :channel_users
    has_many :channel_users

    # 他のモデルを一括で更新、保存できるようにする
    accepts_nested_attributes_for :channel_users
end
