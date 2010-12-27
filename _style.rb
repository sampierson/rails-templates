#
# Some minimal style
#

git_commit "Add some minimal style to shape the layout.\n\n" do
  remove_file 'app/views/layouts/application.html.haml'
  install_template 'app/views/layouts/application.html.haml', :flavor => 'html5'

  remove_file 'app/stylesheets/partials/_page.scss'
  install_template 'app/stylesheets/partials/_page.scss', :flavor => 'html5'

  install_template 'app/stylesheets/partials/_flash.scss'
  append_file 'app/stylesheets/style.scss', "\n@import 'partials/flash';\n"
  gsub_file 'app/views/layouts/_flashes.html.haml',
            ':class => key',
            ':class => "flash #{key}"'

  install_template 'app/stylesheets/partials/_pages.scss'
  append_file 'app/stylesheets/style.scss', "@import 'partials/pages';\n"
end
