gem 'rcov', '>= 0.9.9'
run 'bundle install'

file 'lib/tasks/rcov.rake', <<-EOF
# The rcov task in RSpec2 2.0.0.rc is broken (doesn't add 'spec' to the load path)
desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new('rcov') do |t|
  t.rcov = true
  t.pattern = "./spec/**/*_spec.rb"
  t.rcov_opts = %w{ --rails --include views -Ispec --exclude spec,/gems/ }
end
EOF

git :add => "."
git :commit => "-m 'add rcov support'"
