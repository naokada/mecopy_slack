class Channel < ApplicationRecord
    has_many :messages
    has_many :users, through: :groups_users
    has_many :groups_users
end
