require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "should render" do
      get :index
      response.should render_template('home/index')
    end
  end
end
