#
# Rails 3 application with test framework:
#   RSpec2
#   cucumber
#
apply 'https://github.com/sampierson/rails-templates/raw/master/_base+git.rb'
if defined?(JRUBY_VERSION)
  apply 'http://jruby.org/rails3.rb'
  git :add => '.'
  git :commit => "-m 'JRuby database support'"
end
apply 'https://github.com/sampierson/rails-templates/raw/master/_rspec2.rb'
apply '/Users/sam/Development/SamPierson/rails-templates/_cucumber+webrat.rb'
