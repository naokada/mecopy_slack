class RemoveColumnFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :message_for, :integer
  end
end
