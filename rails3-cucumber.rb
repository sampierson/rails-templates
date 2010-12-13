#
# Rails 3 application with test framework:
#   RSpec2
#   cucumber
#

TEMPLATES_REPOSITORY = ENV['TEMPLATES_REPOSITORY'] || 'https://github.com/sampierson/rails-templates/raw/master'

apply "#{TEMPLATES_REPOSITORY}/_utils.rb"
apply "#{TEMPLATES_REPOSITORY}/_base+git.rb"
apply "#{TEMPLATES_REPOSITORY}/_rspec2.rb"
if RUBY_VERSION =~ /1.9/
  apply "#{TEMPLATES_REPOSITORY}/_cover_me.rb"
else
  apply "#{TEMPLATES_REPOSITORY}/_rcov.rb"
end
apply "#{TEMPLATES_REPOSITORY}/_cucumber+webrat.rb"
