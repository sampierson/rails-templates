#
# Rails 3 application with test framework:
#   RSpec2
#   rcov
#
# Compatible with Ruby 1.8.7
#   Rails 3 requires Ruby 1.8.7
#   rcov does not support Ruby 1.9 at this time
#
apply 'https://github.com/sampierson/rails-templates/raw/master/_base+git.rb'
if defined?(JRUBY_VERSION)
  apply 'http://jruby.org/rails3.rb'
  git :add => '.'
  git :commit => "-m 'JRuby database support'"
end
apply 'https://github.com/sampierson/rails-templates/raw/master/_rspec2.rb'
apply 'https://github.com/sampierson/rails-templates/raw/master/_rcov.rb'
