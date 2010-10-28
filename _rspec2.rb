gem "rspec-rails", ">= 2.0.1", :group => [:development, :test]
run 'bundle install'
git :add => "."
git :commit => "-m 'bundle RSpec2'"

generate :'rspec:install'
git :add => "."
git :commit => "-m 'rails generate rspec:install'"
