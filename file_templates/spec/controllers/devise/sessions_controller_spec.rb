require 'spec_helper'

describe Devise::SessionsController do
  fixtures :users
  
  before do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "when logging in as a regular user" do
    before do
      @user = users(:confirmed_user)
    end

    context "when site_availability is > PREVENT_USER_LOGINS" do
      before do
        AppConfiguration.instance.site_availability = SiteAvailability::PREVENT_NEW_SIGNUPS
      end

      it "should log you in" do
        pending "Enable this again when Rails > 3.0.3?"
        # Using Rails 3.0.3
        # There is a problem with the many locale= calls scattered around rails, causing a deadly embrace
        # between these two fellas and resulting in a "stack level too deep":
        #   actionpack-3.0.3/lib/action_view/lookup_context.rb:175:in `locale='
        #   actionpack-3.0.3/lib/abstract_controller/rendering.rb:28:in `locale='

        post :create, :email => @user.email, :password => 'password'
        response.should be_success
      end
    end

    context "when site_availability is <= PREVENT_USER_LOGINS" do
      before do
        AppConfiguration.instance.site_availability = SiteAvailability::PREVENT_USER_LOGINS
      end

      it "should redirect back to the homepage with a flash message" do
        pending "Enable this again when Rails > 3.0.3?"
        # Using Rails 3.0.3
        # There is a problem with the many locale= calls scattered around rails, causing a deadly embrace
        # between these two fellas and resulting in a "stack level too deep":
        #   actionpack-3.0.3/lib/action_view/lookup_context.rb:175:in `locale='
        #   actionpack-3.0.3/lib/abstract_controller/rendering.rb:28:in `locale='

        post :create, :email => @user.email, :password => 'password'
        response.should be_redirect
        flash[:alert].should =~ /may not sign-up/
      end
    end
  end
end
