git_commit "[Jasmine] Bundle jasmine gem" do
  gem 'jasmine', :group => [:development, :test]
  bundle :install
end

git_commit "[Jasmine] jasmine init" do
  run 'jasmine init'
  remove_file 'public/javascripts/Player.js'
  remove_file 'public/javascripts/Song.js'
  remove_file 'spec/javascripts/PlayerSpec.js'
end

git_commit "[Jasmine] Configure jasmine for our JavaScripts" do
  replace_file 'spec/javascripts/support/jasmine.yml'
end

git_commit "[Jasmine] Disable jasmine rake tasks for production" do
  gsub_file    'lib/tasks/jasmine.rake', /^/, "  "
  prepend_file 'lib/tasks/jasmine.rake', "unless Rails.env == 'production'\n"
  append_file  'lib/tasks/jasmine.rake', "end\n"
end

git_commit "[Jasmine] Add jasmine-jquery extension" do
  install_file 'spec/javascripts/helpers/jasmine-jquery-1.1.3.js'
end

git_commit "[Jasmine] Add JavaScript fixture builder support" do
  append_file '.gitignore', "\n/spec/javascripts/fixtures"
  install_file 'spec/support/js_fixture_builder.rb'
  insert_into_file 'spec/spec_helper.rb', :before => "\nend" do
    "\n  config.include JsFixtureBuilder"
  end
  javascripts_partial = 'app/views/layouts/_javascripts.html.haml'
  gsub_file javascripts_partial, /^/, '  '
  prepend_file javascripts_partial, "#load-javascripts\n"
end
