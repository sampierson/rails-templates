git_commit('bundle haml') do
  gem "haml"
  bundle :install
end

git_commit('get sass files from app/stylesheets') do
  append_file 'config/environment.rb', "\nSass::Plugin.options[:template_location] = Rails.root.join('app', 'stylesheets').to_s\n"
end

git_commit('Haml layout') do
  git :rm => '--quiet app/views/layouts/application.html.erb'
  install_file 'app/views/layouts/application.html.haml'
  install_file 'app/stylesheets/application.sass'
  append_file '.gitignore', '/public/stylesheets'
end
