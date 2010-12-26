#
# Additional steps required to run on Heroku
#

git_commit "Turn on serve_static_assets (for Heroku)" do
  gsub_file "config/environments/production.rb", "serve_static_assets = false", "serve_static_assets = true"
end

git_commit "Turn off SASS compilation in production (for Heroku)" do
  append_file "config/environments/production.rb" do
    "\n\nSass::Plugin.options[:never_update] = true\n"
  end
end

git_commit "Check in CSS files (for Heroku)" do
  gsub_file '.gitignore', "public/stylesheets\n", ''
  run "compass compile"
end
