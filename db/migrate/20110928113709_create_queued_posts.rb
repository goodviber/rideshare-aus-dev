class CreateQueuedPosts < ActiveRecord::Migration
  def change
    create_table :queued_posts, :id => false do |t|
      t.string :page_id
      t.string :post_id
      t.string :fb_id
      t.text :message
      t.timestamp :post_created_at
      t.timestamps
    end
  end
end

