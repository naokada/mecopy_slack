class Direct < ApplicationRecord
  enum dm_type: [:normal, :self_dm]
  has_many :direct_users, dependent: :delete_all
  has_many :users, through: :direct_users
  has_many :messages

  # Return an id of duplicated direct message room when
  # a given user has a direct message room with given users
  # Otherwise, it returns -1
  # It takes an instance of User model and integer arrays of users' id
  def self.get_duplicated_dm_id(user, user_ids)
    user_ids << user.id
    user_ids = user_ids.sort
    user_directs = user.directs

    existed_directs = []
    user_directs.each do |user_direct|
      existed_directs << {id: user_direct.id, user_ids: user_direct.user_ids.sort}
    end

    duplicated_dm = existed_directs.select {|existed_direct| existed_direct[:users_ids] == user_ids}
    if duplicated_dm.length > 0
      return duplicated_dm[0][:id]
    else
      return -1
    end
  end

  def get_name(user)
    if self.dm_type == self
      return user.name
    else
      return "#{self.users.map(&:name).select{|name| name != user.name}.join(", ")}"
    end
    return name
  end
end
