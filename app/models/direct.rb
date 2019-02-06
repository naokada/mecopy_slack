class Direct < ApplicationRecord
  has_many: users, through: :direct_users
  has_many: direct_users
  has_many: messages

  # before_validation: :is_unique

  # def is_unique
  # end
end
