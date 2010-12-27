git_commit('bundle RSpec2') do
  gem "rspec-rails", :group => [:development, :test]
  bundle :install
end

git_commit('rails generate rspec:install') do
  generate :'rspec:install'
end

git_commit('create spec folders') do
  Dir.mkdir('spec/models')
  Dir.mkdir('spec/controllers')
end
