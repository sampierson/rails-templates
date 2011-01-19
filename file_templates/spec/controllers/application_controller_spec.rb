require 'spec_helper'

describe ApplicationController do
  fixtures :users

  controller do
    def index
      head :ok
    end
  end

  describe "#set_locale" do
    before(:all) do
      @default_locale = :'fake_default_locale'
      @valid_locale = :'en'
      I18n.default_locale = @default_locale # so we don't conflict with en-US
    end

    after(:all) do
      I18n.default_locale = 'en'
    end

    before(:each) do
      I18n.locale = 'old_locale'
    end

    context "when neither params[:locale] nor session[:locale] is set" do
      it "should set the locale to the default locale and store it in the session" do
        get :index
        I18n.locale.should == @default_locale
        session[:locale].should == @default_locale
      end
    end

    context "when params[:locale] is set to a bogus locale and session[:locale] is not set" do
      before do
        @params = { :locale => 'nonexistant_locale' }
      end

      it "should set the locale to the default locale and store it in the session" do
        get :index, @params
        I18n.locale.should == @default_locale
        session[:locale].should == @default_locale
      end
    end

    context "when params[:locale] is set to a valid locale and session[:locale] is not set" do
      before do
        @params = { :locale => @valid_locale.to_s }
      end

      it "should set the locale to params[:locale] and store it in the session" do
        get :index, @params
        I18n.locale.should == @valid_locale
        session[:locale].should == @valid_locale.to_s
      end
    end

    context "when params[:locale] is not set and session[:locale] is set to a valid locale" do
      before do
        @params = {}
        session[:locale] = @valid_locale
      end

      it "should set the locale to session[:locale] locale and keep it in the session" do
        get :index, @params
        I18n.locale.should == @valid_locale
        session[:locale].should == @valid_locale
      end
    end

    context "when params[:locale] is set to a valid locale and session[:locale] is set" do
      before do
        @params = { :locale => @valid_locale.to_s }
        session[:locale] = 'some_other_valid_locale' # we only have 1 valid locale right now, but this does not matter for the purposes of this test
      end

      it "should set the locale to params[:locale] and store it in the session" do
        get :index, @params
        I18n.locale.should == @valid_locale
        session[:locale].should == @valid_locale.to_s
      end
    end
  end

  describe "#conditionally_logout_non_admins" do

    context "when site_availability is <= ADMINS_ONLY" do
      before do
        AppConfiguration.instance.site_availability = SiteAvailability::ADMINS_ONLY
      end

      context "when logged in as a regular user" do
        before do
          sign_in users(:confirmed_user)
        end

        it "should redirect to the homepage with a flash message" do
          get :index
          response.should redirect_to("/") # root_path is inaccessible?
          flash[:alert].should =~ /undergoing maintenance/
        end
      end

      context "when logged in as an admin user" do
        before do
          sign_in users(:confirmed_admin_user)
        end

        it "should allow the request" do
          get :index
          response.should be_success
        end
      end

      context "when site_availability is > ADMINS_ONLY" do
        before do
          AppConfiguration.instance.site_availability = SiteAvailability::PREVENT_USER_LOGINS
        end

        context "when logged in as a regular user" do
          before do
            sign_in users(:confirmed_user)
          end

          it "should allow the request" do
            get :index
            response.should be_success
          end
        end

        context "when logged in as an admin user" do
          before do
            sign_in users(:confirmed_admin_user)
          end

          it "should allow the request" do
            get :index
            response.should be_success
          end
        end
      end
    end
  end
end
