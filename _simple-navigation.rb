git_commit "[Simple-navigation] Bundle simple-navigation gem" do
  gem 'simple-navigation'
  bundle :install
end

git_commit "[Simple-navigation] Setup navigation tabs" do

  add_to_locale({
    'navigation' => {
      'administration' => 'Administration',
      'admin' => {
        'settings' => 'Settings',
        'users' => 'Manage users'
      },
      'home' => 'Home',
      'preferences' => 'Preferences',
    },
  })

  install_file 'config/navigation.rb'
  
  append_file 'app/views/layouts/_header.html.haml', <<-EOF
%nav
  = render_navigation :expand_all => true
  EOF
end


