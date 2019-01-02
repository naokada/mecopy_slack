class AddChennelIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :channel_id, :integer, foreign_key: true
  end
end
