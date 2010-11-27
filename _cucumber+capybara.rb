git_commit("bundle cucumber, capybara gems") do
  gem "cucumber-rails", :group => [:development, :test]
  gem "capybara", :group => [:development, :test]
  bundle_install
end

git_commit('rails generate cucumber:install --rspec --capybara') do
  generate :'cucumber:install', '--rspec', '--capybara'
end
