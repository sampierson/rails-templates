git_commit("bundle cucumber, webrat gems") do
  gem "cucumber-rails", :group => [:development, :test]
  gem "nokogiri", :group => [:development, :test]
  gem "webrat", :group => [:development, :test]
  bundle_install
end

git_commit "rails generate cucumber:install --rspec --webrat" do
  generate :'cucumber:install', '--rspec', '--webrat'
end

git_commit 'Change webrat run mode to :rack for Rails3 compatibility' do
  gsub_file 'features/support/env.rb', /config.mode = :rails/, <<-END
  config.mode = :rack
  END
end
