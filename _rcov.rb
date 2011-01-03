git_commit '[Rcov] bundle rcov gem' do
  gem 'rcov', :group => :test
  bundle :install
end

if Rails::VERSION::STRING == "3.0.0"
  git_commit '[Rcov] Add fixed rcov rake task' do
    file 'lib/tasks/rcov.rake', <<-EOF
# The rcov task in RSpec2 2.0.0.rc is broken (doesn't add 'spec' to the load path)
desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new('rcov') do |t|
  t.rcov = true
  t.pattern = "./spec/**/*_spec.rb"
  t.rcov_opts = %w{ --rails --include views -Ispec --exclude spec,/gems/ }
end
    EOF
  end

  git_commit '[Rcov] Get CI to rake rcov instead of spec' do
    gsub_file 'lib/tasks/ci.rake',
              "Rake::Task['spec'].invoke",
              "Rake::Task['rcov'].invoke"
  end
end

