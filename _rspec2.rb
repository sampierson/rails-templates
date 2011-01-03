git_commit '[RSpec2] bundle rspec gems' do
  gem "rspec-rails", :group => [:development, :test]
  bundle :install
end

git_commit '[RSpec2] rails generate rspec:install' do
  generate :'rspec:install'
end

git_commit '[RSpec2] Create spec folders' do
  Dir.mkdir 'spec/models'
  Dir.mkdir 'spec/controllers'
  FileUtils.touch 'spec/models/.gitkeep'
  FileUtils.touch 'spec/controllers/.gitkeep'
end

git_commit '[RSpec2] Create ci rake task' do
  create_file 'lib/tasks/ci.rake', <<-EOF
task :ci do
  Rake::Task['spec'].invoke
end

  EOF
end
