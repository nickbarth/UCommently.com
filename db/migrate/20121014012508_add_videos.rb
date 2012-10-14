class AddVideos < ActiveRecord::Migration
  def up
    create_table :videos do |t|
      t.integer :user_id, null: false
      t.string  :title, null: false, default: ''
      t.string  :image, null: false, default: ''
      t.string  :url, null: false, default: '', unique: true
      t.text    :top_comments, null: false, default: ''
      t.integer :score, null: false, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :videos
  end
end
