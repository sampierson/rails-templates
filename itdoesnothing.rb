#
# Create your application with:
#
#   rails new <name> --skip-test-unit --skip-prototype --template=https://girhub.com/sampierson/rails-templates/raw/master/itdoesnothing.rb
#

TEMPLATES_REPOSITORY = 'https://github.com/sampierson/rails-templates/raw/master'

%w{
  base+git
  rspec2
  cover_me
  cucumber+capybara
  haml
  haml_layout
  home_controller
  devise
  jquery
}.each do |template|
  apply "#{TEMPLATES_REPOSITORY}/_#{template}.rb"
end
