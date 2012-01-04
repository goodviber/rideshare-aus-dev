class SetTripIdNotNull < ActiveRecord::Migration
  def up
    change_column_null(:queued_posts, :trip_id, :false, 0)
  end

  def down
  end
end

