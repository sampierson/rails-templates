git_commit '[cancan] Bundle cancan gem' do
  gem 'cancan'
  bundle :install
end

git_commit '[cancan] Add role column to User' do
  generate :migration, 'add_role_to_users'
  migration_file = Dir.glob('db/migrate/*_add_role_to_users.rb').first
  insert_into_file migration_file, :after => "def self.up\n" do
    "    add_column :users, :role, :string, :default => 'user'\n"
  end
  insert_into_file migration_file, :after => "def self.down\n" do
    "    remove_column :users, :role\n"
  end
end

git_commit '[cancan] Add a fixture file for Users' do
  install_file 'spec/fixtures/users.yml'
  insert_into_file 'spec/models/user_spec.rb', :after => "User do\n" do
    "  fixtures :users\n"
  end
end

git_commit '[cancan] Add User#admin?' do
  insert_into_file 'app/models/user.rb', :before => "\nend" do
    <<-EOF


  def admin?
    role == 'admin' && confirmed_at && !locked_at
  end
    EOF
  end

  insert_into_file 'spec/models/user_spec.rb', :before => "\nend" do
    <<-EOF

  describe "#admin" do
    it "should return true if the user is a confirmed admin user, false otherwise" do
      users(:confirmed_admin_user).should be_admin
      users(:unconfirmed_admin_user).should_not be_admin
      users(:locked_admin_user).should_not be_admin
      users(:unconfirmed_user).should_not be_admin
      users(:unconfirmed_user).should_not be_admin
      users(:locked_user).should_not be_admin
    end
  end
    EOF
  end
end

git_commit '[cancan] Rescue CanCan:AccessDenied exceptions in ApplicationController' do
  insert_into_file 'app/controllers/application_controller.rb', :before => "\nend" do
    <<-EOF

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end
    EOF
  end
end

git_commit '[cancan] Create cancan Ability class' do
  install_file 'app/models/ability.rb'
end
