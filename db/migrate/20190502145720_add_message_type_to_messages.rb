class AddMessageTypeToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :type, :integer, null: false, default: 0
  end
end
