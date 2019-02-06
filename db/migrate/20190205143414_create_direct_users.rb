class CreateDirectUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :direct_users do |t|
      t.references :user, foreign_key: true
      t.references :direct, foreign_key: true

      t.timestamps
    end
  end
end
