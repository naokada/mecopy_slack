class AddTypeToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :channel_type, :integer, null: false, default: 0
  end
end
