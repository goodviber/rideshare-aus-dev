require 'spec_helper'

describe User do

before(:each) do
@attr = {
  :first_name => "Tom",
  :last_name => "Bobaloony",
  :gender => "M"
}
end

pending "should create a new instance given a valid attribute" do
  User.create!(@attr)
end

pending "should reject invalid email addresses" do
  addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
  addresses.each do |address|
    invalid_email_user = User.new(@attr.merge(:email => address))
    invalid_email_user.should_not be_valid
  end
end

it "should be invalid without a facebook id" do
  @user = User.new
  @user.should_not be_valid
end

end

