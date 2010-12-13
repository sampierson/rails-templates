git_commit('bundle haml') do
  gem "haml"
  bundle_install
end

git_commit('get sass files from app/stylesheets') do
  append_file 'config/environment.rb', "\nSass::Plugin.options[:template_location] = Rails.root.join('app', 'stylesheets').to_s\n"
end

git_commit('Haml layout') do
  git :rm => '--quiet app/views/layouts/application.html.erb'
  install_template 'app/views/layouts/application.html.haml'
  install_template 'app/stylesheets/application.sass'
  append_file '.gitignore', '/public/stylesheets'
end
