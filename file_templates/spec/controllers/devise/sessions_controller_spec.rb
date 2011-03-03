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
        post :create, :user => {:email => @user.email, :password => 'password'}
        flash[:notice].should =~ /signed in successfully/i
      end
    end

    context "when site_availability is <= PREVENT_USER_LOGINS" do
      before do
        AppConfiguration.instance.site_availability = SiteAvailability::PREVENT_USER_LOGINS
      end

      it "should redirect back to the homepage with a flash message" do
        post :create, :user => {:email => @user.email, :password => 'password'}
        response.should be_redirect
        flash[:alert].should =~ /undergoing maintenance/
      end
    end
  end
end
