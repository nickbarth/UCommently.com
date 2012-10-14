class AddUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :facebook_id
      t.string  :name
      t.string  :image
      t.string  :access_token
      t.integer :videos_count, null: false, default: 0
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
