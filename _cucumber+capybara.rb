git_commit("[Cucumber] bundle cucumber, capybara gems") do
  gem "cucumber-rails", :group => [:development, :test]
  gem "capybara", :group => [:development, :test]
  bundle :install
end

git_commit('[Cucumber] rails generate cucumber:install --rspec --capybara') do
  generate :'cucumber:install', '--rspec', '--capybara'
end
