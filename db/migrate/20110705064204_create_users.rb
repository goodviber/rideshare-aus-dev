class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :hashed_password, :limit => 40
      t.string :email, :limit => 250
      t.string :city
      t.string :gender, :limit => 1
      t.date :dob
      t.integer :fb_id
      t.datetime :last_login
      t.date :account_expire_on
      t.timestamps
    end
  end
end

