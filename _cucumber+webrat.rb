git_commit("[Cucumber] bundle cucumber, webrat gems") do
  gem "cucumber-rails", :group => [:development, :test]
  gem "nokogiri", :group => [:development, :test]
  gem "webrat", :group => [:development, :test]
  bundle :install
end

git_commit "[Cucumber] rails generate cucumber:install --rspec --webrat" do
  generate :'cucumber:install', '--rspec', '--webrat'
end

git_commit '[Cucumber] Setup cucumber plain and selenium environments' do
  empty_directory 'features/plain'
  empty_directory 'features/selenium'
  empty_directory 'features/support/environments'
  replace_file 'features/support/env.rb',                   :flavor => 'cucumber+selenium'
  install_file 'features/support/environments/selenium.rb', :flavor => 'cucumber+selenium'
  install_file 'features/support/environments/plain.rb',    :flavor => 'cucumber+selenium'
  replace_file 'config/cucumber.yml',                       :flavor => 'cucumber+selenium'
end

git_commit "[Cucumber] Change cucumber rake profile to 'plain'" do
  gsub_file 'lib/tasks/cucumber.rake', "t.profile = 'default'", "t.profile = 'plain'"
end

git_commit "[Cucumber] Add cucumber tests to CI build" do
  insert_into_file 'lib/tasks/ci.rake', :before => /^end/ do
    <<-EOF
  Rake::Task['cucumber'].invoke
    EOF
  end
end
