class AddVotes < ActiveRecord::Migration
  def up
    create_table :votes do |t|
      t.integer :video_id, null: false
      t.string  :user_ip, null: false
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :votes
  end
end
