git_commit("Configure autotest") do
  Dir.mkdir 'autotest'
  file 'autotest/discover.rb', <<-EOF
Autotest.add_discovery { 'rails' }
Autotest.add_discovery { 'rspec2' }
  EOF
end
