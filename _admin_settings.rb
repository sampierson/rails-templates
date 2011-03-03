git_commit '[AdminSettings] Bundle enumerate_it gem' do
  gem 'enumerate_it'
  bundle :install
end

git_commit '[AdminSettings] Add AppConfiguration with site_availability' do
  migration_name = 'create_app_configurations'
  generate :migration, migration_name
  migration_file = Dir.glob("db/migrate/*_#{migration_name}.rb").first
  insert_into_file migration_file, :after => "def self.up\n" do
    <<-EOF
    create_table :app_configurations do |t|
      t.integer :site_availability, :default => 100 # Fully operational
    end
    EOF
  end
  insert_into_file migration_file, :after => "def self.down\n" do
    "drop_table :app_configurations\n"
  end

  install_file 'app/models/app_configuration.rb'
  install_file 'app/models/site_availability.rb'
  add_to_locale({
    'enumerations' => {
      'site_availability' => {
        'admins_only'         => 'Log out everyone but admins',
        'prevent_user_logins' => 'Prevent new user logins',
        'prevent_new_signups' => 'Allow logins but prevent new signups',
        'fully_operational'   => 'Fully operational'
      }
    }
  })
end

git_commit '[AdminSettings] Add site_availability logic' do

  inject_into_file 'app/controllers/application_controller.rb', :after => "protect_from_forgery\n\n" do
    "  before_filter :conditionally_logout_non_admins\n"
  end

  inject_into_file 'app/controllers/application_controller.rb', :before => "\nend\n" do
    <<-EOF

  def conditionally_logout_non_admins
    if user_signed_in? && AppConfiguration.site_availability <= SiteAvailability::ADMINS_ONLY && current_user.role != 'admin'
      flash[:alert] = t('site_availability.maintenance')
      sign_out_and_redirect(:user)
    end
  end
    EOF
  end

  insert_into_file 'app/controllers/devise/registrations_controller.rb', :after => "  include Devise::Controllers::InternalHelpers\n\n" do
    "  before_filter :conditionally_disable_registration\n\n"
  end
  insert_into_file 'app/controllers/devise/registrations_controller.rb', :before => "\nend" do
    <<-EOF

  private

  def conditionally_disable_registration
    if AppConfiguration.site_availability <= SiteAvailability::PREVENT_NEW_SIGNUPS
      flash[:alert] = t('site_availability.sorry_no_signups')
      redirect_to root_path
    end
  end
    EOF
  end
  
  install_file 'app/controllers/devise/sessions_controller.rb'
  install_file 'spec/controllers/application_controller_spec.rb'
  install_file 'spec/controllers/devise/registrations_controller_spec.rb'
  install_file 'spec/controllers/devise/sessions_controller_spec.rb'

  add_to_locale({
    'site_availability' => {
      'legend'           => 'Site Availability',
      'maintenance'      => "Sorry, the site is currently undergoing maintenance. Please check back later.",
      'sorry_no_signups' => "Sorry, new users may not sign-up at this time. Please check back later."
    }
  })
end

git_commit '[AdminSettings] Add admin/settings#edit page' do
  install_file 'app/controllers/admin/settings_controller.rb'
  install_file 'spec/controllers/admin/settings_controller_spec.rb'
  install_file 'app/views/admin/settings/edit.html.haml'

  insert_into_file 'config/routes.rb', :after => "\n  namespace :admin do\n" do
      "    resource :settings, :only => [:edit, :update]\n"
  end

  insert_into_file 'config/navigation.rb', :after => "admin.item :tab_admin_home, I18n.t('navigation.home'), admin_path\n" do
    "      admin.item :tab_admin_home, I18n.t('navigation.admin.site_settings'), edit_admin_settings_path\n"
  end
  
  insert_into_file 'app/views/admin/home/index.html.haml', :after => "\n%ul\n" do
    <<-EOF
  %li
    = link_to t('navigation.admin.site_settings'), edit_admin_settings_path
    EOF
  end

  add_to_locale({
    'crud' => {
      'save' => 'Save'
    },
    'navigation' => {
      'admin' => {
        'site_settings' => 'Site Settings'
      }
    },
    'settings_saved' => 'Settings saved',
    'site_availability' => {
      'legend' => 'Site Availability',
    }
  })
end
