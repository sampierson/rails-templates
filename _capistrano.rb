git_commit '[Capistrano] Bundle capistrano gem' do
  gem 'capistrano', :group => :development
  bundle :install
end

git_commit "[Capistrano] capify" do
  run 'capify .'
  remove_file 'config/deploy.rb'
  install_file 'config/deploy.rb', :method => :template, :source => 'config/deploy.rb.erb'
end

git_commit "[Capistrano] Look for SMTP settings in config/smtp_settings.yml" do

  insert_into_file 'config/environments/production.rb', :before => /^end\n/ do
    <<-EOF

# If deploying via Capistrano this will be a symlink to shared/config/smtp_settings.yml
smtp_settings_file = Rails.root.join('config', 'smtp_settings.yml')
if File.exist?(smtp_settings_file)
  config.action_mailer.smtp_settings = YAML.load_file(Rails.root.join(smtp_settings_file))
end
    EOF
  end
end
