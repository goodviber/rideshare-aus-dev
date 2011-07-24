require 'spec_helper'

describe "demos/new.html.erb" do
  before(:each) do
    assign(:demo, stub_model(Demo,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new demo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => demos_path, :method => "post" do
      assert_select "input#demo_name", :name => "demo[name]"
    end
  end
end
