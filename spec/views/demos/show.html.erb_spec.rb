require 'spec_helper'

describe "demos/show.html.erb" do
  before(:each) do
    @demo = assign(:demo, stub_model(Demo,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
