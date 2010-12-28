#
# Some minimal style
#

git_commit "Add some minimal style to shape the layout.\n\n" do
  remove_file 'app/views/layouts/application.html.haml'
  install_file 'app/views/layouts/application.html.haml', :flavor => 'html5'

  insert_into_file 'app/helpers/application_helper.rb', :before => "\nend" do
    <<-EOF

  # Include ancestors, e.g. Admin::UsersController -> "admin_users"
  def underscored_controller_name
    controller.class.name.underscore.gsub('_controller', '').gsub('/', '_')
  end

  def body_css_classes
    "\#{underscored_controller_name} \#{underscored_controller_name}_\#{action_name}"
  end
    EOF
  end

  remove_file 'app/stylesheets/partials/_page.scss'
  install_file 'app/stylesheets/partials/_page.scss', :flavor => 'html5'

  install_file 'app/stylesheets/partials/_flash.scss'
  append_file 'app/stylesheets/style.scss', "\n@import 'partials/flash';\n"
  gsub_file 'app/views/layouts/_flashes.html.haml',
            ':class => key',
            ':class => "flash #{key}"'

  install_file 'app/stylesheets/partials/_pages.scss'
  append_file 'app/stylesheets/style.scss', "@import 'partials/pages';\n"
end
