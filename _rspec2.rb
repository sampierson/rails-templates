git_commit('bundle RSpec2') do
  gem "rspec-rails", :group => [:development, :test]
  bundle_install
end

git_commit('rails generate rspec:install') do
  generate :'rspec:install'
end
