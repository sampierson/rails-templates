git_commit('Haml layout') do
  git :rm => '--quiet app/views/layouts/application.html.erb'
  install_template 'app/views/layouts/application.html.haml'
  install_template 'app/stylesheets/application.sass'
  append_file '.gitignore', '/public/stylesheets'
end
