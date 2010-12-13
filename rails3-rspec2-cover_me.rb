#
# Rails 3 application with test framework:
#   RSpec2
#   cover_me
#
# For Ruby 1.9 (cover_me is code coverage tool for Ruby 1.9)
#
apply "#{TEMPLATES_REPOSITORY}/_base+git.rb"
if defined?(JRUBY_VERSION)
  apply 'http://jruby.org/rails3.rb'
  git :add => '.'
  git :commit => "-m 'JRuby database support'"
end
apply "#{TEMPLATES_REPOSITORY}/_rspec2.rb"
apply "#{TEMPLATES_REPOSITORY}/_cover_me.rb"
