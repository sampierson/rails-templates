#
# Create your application with:
#
#   rails new <name> --skip-test-unit --skip-prototype --template=https://girhub.com/sampierson/rails-templates/raw/master/itdoesnothing.rb
#

TEMPLATES_REPOSITORY = ENV['TEMPLATES_REPOSITORY'] || 'https://github.com/sampierson/rails-templates/raw/master'

TEMPLATES = [
  'utils',
  'base+git',
  'debug',
  'rspec2',
  (RUBY_VERSION =~ /1.9/ ? 'cover_me' : 'rcov'),  # Test coverage measurement
  'cucumber+capybara',                            # Integration test framework: cucumber-capybara cucumber+webrat
  'compass+html5',                                # Templating/layout: haml compass+blueprint compass+html5
  'style',                                        # Customize layout
  'home_controller',                              # A simple controller around which we can wrap authentication
  'devise',                                       # Authentication
  'cancan',
  # 'jquery' - done already if we're using compass+html5
  'i18n',
  'admin_users',
  'herokuize'
].each do |template|
  apply "#{TEMPLATES_REPOSITORY}/_#{template}.rb"
end

git_commit "Change logo to itdoesnothing" do
  gsub_file 'app/views/layouts/_header.html.haml', 'Logo', "It Does Nothing!"
end
