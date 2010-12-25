git_commit("bundle haml, compass, html5-boilerplate gems") do
  gem "haml"
  gem "compass"
  gem "html5-boilerplate"
  bundle_install
end

run_and_commit('compass init rails -r html5-boilerplate -u html5-boilerplate --force --sass-dir app/stylesheets --css-dir public/stylesheets',
               :message => 'compass init')

git_commit 'gitignore public/stylesheets' do
  append_file '.gitignore', "public/stylesheets\n"
end

git_commit 'Remove layouts/application.html.erb' do
  git :rm => 'app/views/layouts/application.html.erb'
end
