gem "rspec-rails", ">= 2.0.0.rc", :group => [:development, :test]
run 'bundle install'
git :add => "."
git :commit => "-m 'bundle RSpec2'"

generate :'rspec:install'
git :add => "."
git :commit => "-m 'rails generate rspec:install'"
