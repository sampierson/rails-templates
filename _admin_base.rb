# Create Admin::BaseController
# and Admin::HomeController

git_commit "[AdminBase] Create admin#home page" do
  insert_into_file 'config/routes.rb', :before => "\nend" do
    <<-EOF

  match 'admin' => 'admin/home#index'
    EOF
  end

  insert_into_file 'config/navigation.rb', :before => "  end\nend\n" do
    <<-EOF

    primary.item :admin, I18n.t('navigation.administration'), admin_path, :if => Proc.new { user_signed_in? && current_user.admin? } do |admin|
      admin.item :home, I18n.t('navigation.home'), admin_path
    end # :admin
    EOF
  end

  add_to_locale({
    'not_authorized' => "I'm sorry, you're not authorized to access that page."
  })

  install_file 'app/controllers/admin/base_controller.rb'
  install_file 'app/controllers/admin/home_controller.rb'
  install_file 'app/views/admin/home/index.html.haml'
end
