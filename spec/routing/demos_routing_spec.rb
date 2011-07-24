require "spec_helper"

describe DemosController do
  describe "routing" do

    it "routes to #index" do
      get("/demos").should route_to("demos#index")
    end

    it "routes to #new" do
      get("/demos/new").should route_to("demos#new")
    end

    it "routes to #show" do
      get("/demos/1").should route_to("demos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/demos/1/edit").should route_to("demos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/demos").should route_to("demos#create")
    end

    it "routes to #update" do
      put("/demos/1").should route_to("demos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/demos/1").should route_to("demos#destroy", :id => "1")
    end

  end
end
