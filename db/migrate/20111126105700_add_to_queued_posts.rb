class AddToQueuedPosts < ActiveRecord::Migration
  def up
    add_column :queued_posts, :trip_id, :integer
    add_column :queued_posts, :process_type, :text
    add_column :queued_posts, :error_msg, :text
    add_column :queued_posts, :processed_at, :datetime
    add_column :queued_posts, :deleted_at, :datetime
  end

  def down
    remove_column :queued_posts, :trip_id
    remove_column :queued_posts, :process_type
    remove_column :queued_posts, :error_msg
    remove_column :queued_posts, :processed_at
    remove_column :queued_posts, :deleted_at
  end
end

