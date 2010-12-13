git_commit('bundle devise gem') do
  gem 'devise'
  bundle_install
end

git_commit('rails generate devise:install') do
  generate :'devise:install'
end

git_commit('changes suggested by devise:install') do
  inject_into_file 'config/environments/development.rb', :before => /^end\n/ do
    "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\n"
  end
end

git_commit('rails generate devise User') do
  generate :'devise', 'User'
end

git_commit('devise links in layout') do
  inject_into_file 'app/views/layouts/application.html.haml', :after => "#container\n" do
    <<-EOF
      #user_nav
        - if user_signed_in?
          Signed in as \#{current_user.email}. Not you?
          = link_to "Sign out", destroy_user_session_path
        - else
          = link_to "Sign up", new_user_registration_path
          or
          = link_to "sign in", new_user_session_path
    EOF
  end

  if File.exist?('app/stylesheets/application.sass')
    append_file 'app/stylesheets/application.sass', <<-EOF

#user_nav
  float: right
  font-size: 12px
    EOF
  end
end

