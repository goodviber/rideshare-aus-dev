class AddAttachmentPhotoToEvent < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :event_id, :null => false
      t.string  :photo_file_name
      t.string  :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
    end
  end

  def self.down
    drop_table :photos
  end
end
