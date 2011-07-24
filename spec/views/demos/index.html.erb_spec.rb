require 'spec_helper'

describe "demos/index.html.erb" do
  before(:each) do
    assign(:demos, [
      stub_model(Demo,
        :name => "Name"
      ),
      stub_model(Demo,
        :name => "Name"
      )
    ])
  end

  it "renders a list of demos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
