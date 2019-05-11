class AddTypeToDirects < ActiveRecord::Migration[5.2]
  def change
    add_column :directs, :dm_type, :integer, null: false, default: 0
  end
end
