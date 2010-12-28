git_commit "Bundle jasmine gem" do
  gem 'jasmine'
  bundle :install
end

git_commit "jasmine init" do
  run 'jasmine init'
  remove_file 'public/javascripts/Player.js'
  remove_file 'public/javascripts/Song.js'
  remove_file 'spec/javascripts/PlayerSpec.js'
end
