class CreateDirectMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_messages do |t|
      t.text :content
      t.integer :direct_id,    foreign_key: true
      t.integer :user_id,      foreign_key: true
      t.timestamps
    end
  end
end
