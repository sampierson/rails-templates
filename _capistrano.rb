git_commit '[Capistrano] Bundle capistrano gem' do
  gem 'capistrano', :group => :development
  bundle :install
end

git_commit "[Capistrano] capify" do
  run 'capify .'
  remove_file 'config/deploy.rb'
  install_file 'config/deploy.rb', :method => :template, :source => 'config/deploy.rb.erb'
end
