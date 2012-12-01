class AddCoordinatesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :latitude,  :string, :limit => 1000
    add_column :events, :longitude, :string, :limit => 1000
  end
end
