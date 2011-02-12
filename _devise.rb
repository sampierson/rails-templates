git_commit '[Devise] Bundle devise gem' do
  gem 'devise'
  bundle :install
end

git_commit '[Devise] rails generate devise:install' do
  generate :'devise:install'
end

git_commit '[Devise] Configure devise initializer' do
  gsub_file 'config/initializers/devise.rb',
            'config.mailer_sender = "please-change-me@config-initializers-devise.com"',
            "config.mailer_sender = \"no-reply@#{app_name}.com\""
  gsub_file 'config/initializers/devise.rb',
            '# config.confirm_within = 2.days',
            'config.confirm_within = 0'
  gsub_file 'config/initializers/devise.rb',
            '# config.lock_strategy = :failed_attempts',
            'config.lock_strategy = :failed_attempts'
  gsub_file 'config/initializers/devise.rb',
            '# config.unlock_strategy = :both',
            'config.unlock_strategy = :none'
  gsub_file 'config/initializers/devise.rb',
            '# config.maximum_attempts = 20',
            'config.maximum_attempts = 8'
end

git_commit '[Devise] Changes suggested by devise:install' do
  # We're going to setup action_mailer.default_url_options
  inject_into_file "config/environments/development.rb", :before => /^end\n/ do
    "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\n"
  end
  inject_into_file "config/environments/test.rb", :before => /^end\n/ do
    "\n  config.action_mailer.default_url_options = { :host => 'example.com:3000' }\n"
  end
  if ENV['DEPLOY_STRATEGY'] == 'heroku'
    # However there is a Heroku 'feature' we have to work around:
    #   If the string 'action_mailer' appears in config/environments/production.rb, Heroku setup of sendgrid fails
    # Because of this, we will put the production value in application.rb
    inject_into_file "config/application.rb", :before => /^  end\nend\n/ do
      "\n    config.action_mailer.default_url_options = { :host => '#{app_name}.com' }\n"
    end
  else
    inject_into_file "config/environments/production.rb", :before => /^end\n/ do
      "\n  config.action_mailer.default_url_options = { :host => '#{app_name}.com' }\n"
    end
  end
end

git_commit "[Devise] rails generate devise User\n\nand delete the 'pending' test from the User spec file" do
  generate :'devise', 'User'
  replace_file  'spec/models/user_spec.rb'
end

git_commit '[Devise] Turn on :confirmable and :lockable' do
  gsub_file 'app/models/user.rb',
            '# :token_authenticatable, :confirmable, :lockable and :timeoutable',
            '# :token_authenticatable and :timeoutable'
  gsub_file 'app/models/user.rb',
            /:validatable\n/,
            ":validatable,\n         :confirmable, :lockable\n"

  migration_file = Dir.glob('db/migrate/*_devise_create_users.rb').first
  raise "Can't find Devise migration file" unless migration_file

  gsub_file migration_file,
            '# t.confirmable',
            't.confirmable'
  gsub_file migration_file,
            '# t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :none',
            't.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :none'
  gsub_file migration_file,
            '# add_index :users, :confirmation_token,   :unique => true',
            'add_index :users, :confirmation_token,   :unique => true'
  add_to_locale({
    'devise' => {
      'registrations' => {
        'signed_up' => "You have registered successfully and have been sent a confirmation email.  To complete the sign-up progess, please click on the link contained in that email."        
      }
    }
  }, 'config/locales/devise.en.yml')
end

git_commit '[Devise] Add shared examples for controller authentication specs' do
  install_file 'spec/shared_examples/authentication.rb'
end

git_commit '[Devise] Add devise login/registration links to layout' do

  if File.exist? 'app/views/layouts/_header.html.haml' # Assume we are using Compass HTML5-Boilerplate
    replace_file 'app/views/layouts/_header.html.haml'
    gsub_file 'app/stylesheets/partials/_page.scss', "header {}\n", <<-EOF10
header {
  #user_nav {
    float: right;
  }
}
    EOF10
  else
    inject_into_file 'app/views/layouts/application.html.haml', :after => "#container\n" do
      <<-EOF30
      #user_nav
        - if user_signed_in?
          Signed in as \#{current_user.email}. Not you?
          = link_to "Sign out", destroy_user_session_path
        - else
          = link_to "Sign up", new_user_registration_path
          or
          = link_to "Sign in", new_user_session_path
      EOF30
    end

    if File.exist? 'app/stylesheets/application.sass'
      append_file 'app/stylesheets/application.sass', <<-EOF40

#user_nav
  float: right
  font-size: 12px
      EOF40
    end
  end

  add_to_locale({
    'devise' => {
      'sessions' => {
        'login'        => "Login",
        'sign_in'      => "Sign in",
        'signed_in'    => "Signed in successfully.",
        'sign_out'     => "Sign out",
        'signed_in_as' => "Signed in as %{user}",
        'signed_out'   => "Signed out successfully."
      },
      'passwords' => {
        'forgot' => "Forgot your password?"
      },
      'registrations' => {
        'already_question' => "Already have an account?",
        'dont_have_an_account' => "Don't have an account?",
        'sign_up' => "Sign up"
      }
    }
  }, 'config/locales/devise.en.yml')
end

git_commit '[Devise] rails generate devise:views' do
  generate :'devise:views'
end

git_commit '[Devise] HAMLize some Devise templates' do
  %w{
    sessions/new
    registrations/new
  }.each do |file|
    git :rm => "app/views/devise/#{file}.html.erb"
    install_file "app/views/devise/#{file}.html.haml"
  end
end

git_commit '[Devise] Cucumber test for authentication' do
  features_path = File.exist?('features/plain') ? 'features/plain' : 'features'
  install_file "#{features_path}/authentication.feature", :source => 'features/authentication.feature'

  insert_into_file 'features/step_definitions/web_steps.rb',
                   :after => 'Then /^(?:|I )should be on (.+)$/ do |page_name|' do
    <<-EOF
  simulate do
    if response.redirect?
      visit response.headers['Location']
    end
  end
    EOF
  end

  install_file 'features/step_definitions/devise_steps.rb'
  insert_into_file 'features/support/paths.rb', :before => "    # Add more mappings here." do
    <<-EOF
  when /the sign in page/; new_user_session_path

  when /the confirmation link for user "([^"]+)"/
    user = User.find_by_email($1)
    user_confirmation_url(user, :confirmation_token => user.confirmation_token)

    EOF
  end
end
