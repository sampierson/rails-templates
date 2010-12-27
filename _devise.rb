git_commit 'Bundle devise gem' do
  gem 'devise'
  bundle :install
end

git_commit 'rails generate devise:install' do
  generate :'devise:install'
end

git_commit 'Configure devise initializer' do
  gsub_file 'config/initializers/devise.rb',
            'config.mailer_sender = "please-change-me@config-initializers-devise.com"',
            'config.mailer_sender = "no-reply@itdoesnothing.com"'
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

git_commit 'Changes suggested by devise:install' do
  [
    { :environment => :development, :email_from_host => 'localhost:3000' },
    { :environment => :test,        :email_from_host => 'localhost:3000' },
    { :environment => :production,  :email_from_host => 'itdoesnothing.com' }
  ].each do |info|
    inject_into_file "config/environments/#{info[:environment]}.rb", :before => /^end\n/ do
      "\n  config.action_mailer.default_url_options = { :host => '#{info[:email_from_host]}' }\n"
    end
  end
end

git_commit 'rails generate devise User' do
  generate :'devise', 'User'
end

git_commit 'Turn on :confirmable and :lockable' do
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
  gsub_file 'config/locales/devise.en.yml',
            "signed_up: 'You have signed up successfully. If enabled, a confirmation was sent to your e-mail.'",
            "signed_up: 'You have registered successfully and have been sent a confirmation email.  To complete the sign-up progess, please click on the link contained in that email.'"

end

git_commit 'Add devise login/registration links to layout' do

  header_template = 'app/views/layouts/_header.html.haml'
  if File.exist? header_template # Assume we are using Compass HTML5-Boilerplate
    remove_file header_template
    install_file header_template
    gsub_file 'app/stylesheets/partials/_page.scss', "header {}\n", <<-EOF10
header {
  #user_nav {
    float: right;
  }
}
    EOF10

    gsub_file 'config/locales/devise.en.yml', "    sessions:\n", <<-EOF20
    sessions:
      login: Login
      sign_in: Sign in
      signed_in: 'Signed in successfully.'
      sign_out: Sign out
      signed_in_as: Signed in as %{user}.
      signed_out: 'Signed out successfully.'
    EOF20

    gsub_file 'config/locales/devise.en.yml', "    passwords:\n", <<-EOF25
    passwords:
      forgot: Forgot your password?
    EOF25

    gsub_file 'config/locales/devise.en.yml', "    registrations:\n", <<-EOF25
    registrations:
      already_question: "Already have an account?"
      dont_have_an_account: "Don't have an account?"
      sign_up: Sign up
    EOF25

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
  end

  if File.exist? 'app/stylesheets/application.sass'
    append_file 'app/stylesheets/application.sass', <<-EOF40

#user_nav
  float: right
  font-size: 12px
    EOF40
  end
end

git_commit 'rails generate devise:views' do
  generate :'devise:views'
end

git_commit 'HAMLize some Devise templates' do
  %w{
    sessions/new
    registrations/new
  }.each do |file|
    git :rm => "app/views/devise/#{file}.html.erb"
    install_file "app/views/devise/#{file}.html.haml"
  end
end
