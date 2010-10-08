#
# Rails 3 application with test framework:
#   RSpec2
#   cover_me
#
# For Ruby 1.9 (cover_me is code coverage tool for Ruby 1.9)
#
apply 'http://github.com/ombwa/rails-templates/raw/master/_base+git.rb'
if defined?(JRUBY_VERSION)
  apply 'http://jruby.org/rails3.rb'
  git :add => '.'
  git :commit => "-m 'JRuby database support'"
end
apply 'http://github.com/ombwa/rails-templates/raw/master/_rspec2.rb'
