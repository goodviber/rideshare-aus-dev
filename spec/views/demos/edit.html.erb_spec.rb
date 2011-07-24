require 'spec_helper'

describe "demos/edit.html.erb" do
  before(:each) do
    @demo = assign(:demo, stub_model(Demo,
      :name => "MyString"
    ))
  end

  it "renders the edit demo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => demos_path(@demo), :method => "post" do
      assert_select "input#demo_name", :name => "demo[name]"
    end
  end
end
