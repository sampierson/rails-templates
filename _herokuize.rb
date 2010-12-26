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

if File.exist? 'lib/tasks/cover_me.rake'
  git_commit "Disable cover_me rake tasks in production" do
    gsub_file    'lib/tasks/cover_me.rake', /^/, '  '
    prepend_file 'lib/tasks/cover_me.rake', "unless Rails.env == 'production'\n"
    append_file  'lib/tasks/cover_me.rake', "\nend\n"
  end
end
