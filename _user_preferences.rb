git_commit '[UserPreferences] Add user preferences page' do
  install_file 'app/controllers/preferences_controller.rb'
  install_file 'spec/controllers/preferences_controller_spec.rb'
  install_file 'app/views/preferences/edit.html.haml'
  install_file 'app/stylesheets/partials/_form.scss'
  append_file 'app/stylesheets/style.scss', "@import 'partials/form';\n"
  inject_into_file 'config/routes.rb', :after => "  get \"home/index\"\n" do
    <<-EOF

  resource :preferences, :only => [:edit, :update] do
    put :change_password
  end
    EOF
  end
end

add_to_locale({
  'field' => {
    'current_password' => "Current password",
    'new_password' => "New password",
    'new_password_confirmation' => "Confirm new password"
  },
  'preferences' => {
    'bad_old_password' => "Your old password was not correct, password was not changed.",
    'must_supply_old_and_new_passwords' => "You must fill in the old and new passwords to change your password",
    'password_update_problem' => "There was a problem changing your password",
    'password_updated' => "Your password has been changed"
  }
}, 'config/locales/en.yml')
