class CreateDirects < ActiveRecord::Migration[5.2]
  def change
    create_table :directs do |t|

      t.timestamps
    end
  end
end
