class RemoveFbidFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :fb_id
  end

  def down
    add_column :user, :fb_id, :string
  end
end

