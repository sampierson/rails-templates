require 'spec_helper'

describe Devise::RegistrationsController do
  before do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "when site_availability is > PREVENT_NEW_SIGNUPS" do
    before do
      AppConfiguration.instance.site_availability = SiteAvailability::FULLY_OPERATIONAL
    end

    it "should render as normal" do
      get :new
      response.should be_success
    end
  end

  context "when site_availability is <= PREVENT_NEW_SIGNUPS" do
    before do
      AppConfiguration.instance.site_availability = SiteAvailability::PREVENT_NEW_SIGNUPS
    end

    it "should redirect back to the homepage with a flash message" do
      get :new
      response.should be_redirect
      flash[:alert].should =~ /may not sign-up/
    end
  end
end
