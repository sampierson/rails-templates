#
# Admin::UsersController
#

git_commit "[AdminUsers] Bundle will_paginate gem" do
  if RUBY_VERSION =~ /1.9/
    gem 'will_paginate', '3.0.pre2'
  else
    gem 'will_paginate'
  end

  bundle :install
end

git_commit "[AdminUsers] Create Admin::UsersController" do
  install_file 'app/controllers/admin/users_controller.rb'
  install_file 'spec/controllers/admin/users_controller_spec.rb'
  insert_into_file 'spec/spec_helper.rb', :before => "\nend" do
    "\n  config.include Devise::TestHelpers, :type => :controller"
  end  
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

  insert_into_file 'spec/models/user_spec.rb', :before => "\nend" do
    <<-EOF

  describe ".search" do
    it "should execute a LIKE query with the supplied argument" do
      User.should_receive(:where).with("email LIKE ?", "%foo%")
      User.search("foo")
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

  insert_into_file 'config/navigation.rb', :before => "    end # :admin\n" do
    <<-EOF
      admin.item :tab_admin_users, I18n.t('navigation.admin.users'), admin_users_path
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

  add_to_locale({
    "activerecord" => {
      "models" => {
        "user" => "User"
      },
      "attributes" => {
        "user" => {
          "confirmed_at" => "Confirmed",
          "created_at" => "Created",
          "current_sign_in_at" => "Current sign-in at",
          "current_sign_in_ip" => "Current sign-in ip",
          "email" => "Email address",
          "locked_at" => "Locked",
          "password" => "Password",
          "role" => "Role",
          "sign_in_count" => "Sign-ins"
        }
      }
    },
    "at" => "At",
    "current_sign_in" => "Current sign-in",
    "time_ago" => "%{time} ago",
    "users" => "Users",
    "from_ip" => "From IP",
    "last_sign_in" => "Last sign-in",
    "search" => "Search"
  })

  install_file 'public/images/up_arrow.gif'
  install_file 'public/images/down_arrow.gif'

  install_file "public/javascripts/#{app_name}/pages/AdminUsersIndexPage.js",
    :source => "public/javascripts/app_name/pages/AdminUsersIndexPage.js",
    :method => :template
  
  if File.directory?('spec/javascripts')
    install_file "spec/javascripts/pages/AdminUsersIndexPageSpec.js",
      :source => "spec/javascripts/pages/AdminUsersIndexPageSpec.js",
      :method => :template
  end
end
