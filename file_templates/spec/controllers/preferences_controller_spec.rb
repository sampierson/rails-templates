require 'spec_helper'
require File.join(File.dirname(__FILE__), '..', 'shared_examples', 'authentication')

describe PreferencesController do
  fixtures :users
  
  it_should_behave_like "a controller that only allows logged in users to access actions", {:get => :edit, :put => :update, :put => :change_password }

  context "when logged in" do
    before do
      @current_user = users(:confirmed_user)
      sign_in @current_user
    end

    describe "#change_password" do
      it "should require old, new and confirmation passwords" do
        [
          {},
          {:old_password => "foo"},
          {:old_password => "foo", :password => "new password"},
          {:password => "new password", :password_confirmation => "new password"}
        ].each do |params|
          put :change_password, params
          response.should redirect_to edit_preferences_path
          flash[:alert].should =~ /must fill in the old and new passwords/
        end
      end

      it "should require a successful authentication with the old password" do
        controller.stub!(:current_user) { @current_user }
        @current_user.should_not_receive(:update_attributes)

        put :change_password, :old_password => "not the old password", :user => { :password => "foo", :password_confirmation => "foo"}
        response.should redirect_to edit_preferences_path
        flash[:alert].should =~ /old password was not correct/
      end

      it "should change the password" do
        controller.stub!(:current_user) { @current_user }
        @current_user.should_receive(:update_attributes).with(:password => "new_password", :password_confirmation => "new_password").and_return(true)

        put :change_password, :old_password => "password", :user => { :password => "new_password", :password_confirmation => "new_password"}

        response.should redirect_to edit_preferences_path
        flash[:notice].should =~ /password has been changed/
      end

      it "should catch passwords that don't conform to policy (e.g. too short)" do
        put :change_password, :old_password => "password", :user => { :password => "short", :password_confirmation => "short" }

        response.should render_template('preferences/edit')
        flash[:alert].should =~ /problem/
      end

      it "should only change the password" do
        controller.stub!(:current_user) { @current_user }
        @current_user.should_receive(:update_attributes).with(:password => "new_password", :password_confirmation => "new_password").and_return(true)

        put :change_password,
            :old_password => "password",
            :user => { :password => "new_password",
                       :password_confirmation => "new_password",
                       :email => "new@email.com" }

        response.should redirect_to edit_preferences_path
        flash[:notice].should =~ /password has been changed/

      end
    end
  end

end
