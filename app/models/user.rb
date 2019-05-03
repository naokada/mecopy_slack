class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  has_many :messages
  has_many :channel_users, dependent: :delete_all
  has_many :channels, through: :channel_users
  has_many :direct_users, dependent: :delete_all
  has_many :directs, through: :direct_users
  has_one_attached :avator

  after_save :add_default_dm

  def add_default_dm
    direct = Direct.create
    direct.users << self
  end
end
