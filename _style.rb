#
# Some minimal style
#

git_commit "Add some minimal style to shape the layout.\n\n" do
  remove_file 'app/views/layouts/application.html.haml'
  install_template 'app/views/layouts/application.html.haml', :flavor => 'html5'
  remove_file 'app/stylesheets/partials/_page.scss'
  install_template 'app/stylesheets/partials/_page.scss', :flavor => 'html5'
end
