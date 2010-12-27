git_commit 'Bundle cancan gem' do
  gem 'cancan'
  bundle_install
end

git_commit 'Add role column to User' do
  generate :migration, 'add_role_to_users'
  migration_file = Dir.glob('db/migrate/*_add_role_to_users.rb').first
  puts "SAM: migration_file = #{migration_file}"
  insert_into_file migration_file, :after => "def self.up\n" do
    <<-EOF
    add_column :users, :role, :string, :default => 'user'
    EOF
  end
  insert_into_file migration_file, :after => "def self.down\n" do
    <<-EOF
    remove_column :users, :role
    EOF
  end
end

git_commit 'Add User#admin?' do
  insert_into_file 'app/models/user.rb', :before => "end\n" do
    <<-EOF
    
  def admin?
    role == 'admin'
  end
    EOF
  end
end

git_commit 'Add User#admin?' do
  insert_into_file 'app/controllers/application_controller.rb', :before => "end\n" do
    <<-EOF
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

    EOF
  end
end

git_commit 'Create cancan Ability class' do
  install_template 'app/models/ability.rb'
end
