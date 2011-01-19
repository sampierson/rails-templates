require 'spec_helper'

describe Admin::UsersController do
  fixtures :users

  context "when not logged in" do
    it "should redirect back to the login page with a flash message" do
      sign_out(:user)
      get :index
      response.should redirect_to(new_user_session_path)
      flash[:alert].should include("need to sign in")
    end
  end

  context "when logged in as a regular user" do
    before do
      sign_in users(:confirmed_user)
    end

    it "should redirect back to the home page with a flash message" do
      get :index
      response.should redirect_to(root_path)
      flash[:alert].should include("not authorized")
    end
  end

  context "while logged in as an admin user" do
    before do
      sign_in users(:confirmed_admin_user)
    end

    describe "#index" do
      it "should populate @users" do
        get :index
        response.should be_success
        assigns(:users).size.should > 0
      end

      it "should respect sort column and direction" do
        mock_search_scope = double('search_scope')
        User.stub(:search) { mock_search_scope }

        mock_search_scope.should_receive(:order).with("created_at desc").and_return([])

        get :index, :sort => 'created_at', :direction => 'desc'
      end
      
      it "should respect pagination" do
        mock_search_scope = double('search_scope')
        mock_order_scope  = double('order_scope')
        User.stub(:search) { mock_search_scope }
        mock_search_scope.stub(:order) { mock_order_scope }

        mock_order_scope.should_receive(:paginate).with(:per_page => 10, :page => "34")

        get :index, :page => "34"
      end

      it "should handle search" do
        mock_search_scope = double('search_scope')
        mock_search_scope.stub(:order) { [] }

        User.should_receive(:search).with("fake_search").and_return(mock_search_scope)

        get :index, :search => 'fake_search'
      end
    end

    context "rendering views" do
      render_views

      it "gets saved as a fixture" do
        get :index
        response.should be_success
        save_fixture(html_for('body'), 'admin_users_controller_index')
      end
    end

  end
end
