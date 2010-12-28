git_commit "Bundle jasmine gem" do
  gem 'jasmine', :group => [:development, :test]
  bundle :install
end

git_commit "jasmine init" do
  run 'jasmine init'
  remove_file 'public/javascripts/Player.js'
  remove_file 'public/javascripts/Song.js'
  remove_file 'spec/javascripts/PlayerSpec.js'
end

git_commit "disable jasmine rake tasks for production" do
  gsub_file    'lib/tasks/jasmine.rake', /^/, "  "
  prepend_file 'lib/tasks/jasmine.rake', "unless Rails.env == 'production'\n"
  append_file  'lib/tasks/jasmine.rake', "end\n"
end
