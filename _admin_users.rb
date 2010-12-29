#
# Admin::UsersController
#

git_commit "Bundle will_paginate gem" do
  gem 'will_paginate', '3.0.pre2'
  bundle :install
end

git_commit "Create Admin::UsersController" do
  install_file 'app/controllers/admin/users_controller.rb'
  install_file 'spec/controllers/admin/users_controller_spec.rb'
  install_file 'app/views/admin/users/index.html.haml'
  install_file 'app/views/admin/users/_users.html.haml'
  install_file 'app/views/admin/users/index.js.erb'
  insert_into_file 'app/models/user.rb', :before => "\nend" do
    <<-EOF


  def self.search(search)
    if search
      where('email LIKE ?', "%\#{search}%")
    else
      scoped
    end
  end
    EOF
  end

  insert_into_file 'app/helpers/application_helper.rb', :before => "\nend" do
    <<-EOF

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column.to_s == sort_column) ? "current_sort \#{sort_direction}" : nil
    direction = (column.to_s == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def time_ago(time)
    time ? distance_of_time_in_words(Time.now - time) + " ago" : '&nbsp;'.html_safe
  end
    EOF
  end

  insert_into_file 'config/routes.rb', :before => "\nend" do
    <<-EOF

  namespace :admin do
    resources :users
  end
    EOF
  end

  append_file 'app/stylesheets/partials/_pages.scss' do
    <<-EOF

.admin_users {
  td.sign_in_count, td.role {
    text-align: center;
  }
}
    EOF
  end

  install_file 'app/stylesheets/partials/_table.scss'
  append_file 'app/stylesheets/style.scss', "@import 'partials/table';\n"

  remove_file 'config/locales/en.yml'
  install_file 'config/locales/en.yml'

  install_file 'public/images/up_arrow.gif'
  install_file 'public/images/down_arrow.gif'

  install_file "public/javascripts/#{app_name}/pages/AdminUsersIndexPage.js",
    :source => "public/javascripts/app_name/pages/AdminUsersIndexPage.js", :template => true
  
  if File.directory?('spec/javascripts')
    install_file "spec/javascripts/pages/AdminUsersIndexPageSpec.js",
      :source => "spec/javascripts/pages/AdminUsersIndexPageSpec.js", :template => true
  end
end
