shared_examples_for "a controller that only allows logged in users to access actions" do |actions|
  context "while logged out" do
    before do
      setup_controller_for_warden
      request.env["devise.mapping"] = Devise.mappings[:user]
      sign_out :user
    end

    actions.each do |method, action|
      describe action do
        it "should redirect to login page with an error message" do
          send(method, action)
          response.should redirect_to new_user_session_path
          flash[:alert].should =~ /need to sign in/
        end
      end
    end
  end
end

