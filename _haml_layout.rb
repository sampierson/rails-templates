git_commit('Haml layout') do
  git :rm => '--quiet app/views/layouts/application.html.erb'
  template "#{TEMPLATES_REPOSITORY}/file_templates/app/views/layouts/application.html.haml", 'app/views/layouts/application.html.haml'

  template "#{TEMPLATES_REPOSITORY}/file_templates/app/stylesheets/application.sass", 'app/stylesheets/application.sass'
  
  append_file '.gitignore', '/public/stylesheets'
end
