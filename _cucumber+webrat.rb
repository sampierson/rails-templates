gem "cucumber-rails", :group => [:development, :test]
gem "nokogiri", :group => [:development, :test]
gem "webrat", :group => [:development, :test]
run 'bundle install'
git :add => "."
git :commit => "-m 'bundle cucumber, webrat gems'"

generate :'cucumber:install', '--rspec', '--webrat'
git :add => "."
git :commit => "-m 'rails generate cucumber:install --rspec --webrat'"

gsub_file 'features/support/env.rb', /config.mode = :rails/, <<-END
  config.mode = :rack
END
git :add => "."
git :commit => "-m 'Change webrat run mode to :rack for Rails3 compatibility'"
