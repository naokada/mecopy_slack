class DirectUser < ApplicationRecord
  belongs_to :user
  belongs_to :direct
end
