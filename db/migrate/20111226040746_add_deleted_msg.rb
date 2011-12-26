class AddDeletedMsg < ActiveRecord::Migration
  def up
    add_column :queued_posts, :deleted_msg, :text
  end

  def down
  end
end

