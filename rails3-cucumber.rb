#
# Rails 3 application with test framework:
#   RSpec2
#   cucumber
#
apply "#{TEMPLATES_REPOSITORY}/_base+git.rb"
if defined?(JRUBY_VERSION)
  apply 'http://jruby.org/rails3.rb'
  git :add => '.'
  git :commit => "-m 'JRuby database support'"
end
apply "#{TEMPLATES_REPOSITORY}/_rspec2.rb"
apply "#{TEMPLATES_REPOSITORY}/_cucumber+webrat.rb"
