class Channel < ApplicationRecord
    has_many :messages
    has_many :users, through: :channels_users
    has_many :channels_users
end
