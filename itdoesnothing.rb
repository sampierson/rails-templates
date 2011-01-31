#
# Create your application with:
#
#   rails new <name> --skip-test-unit --skip-prototype --template=https://girhub.com/sampierson/rails-templates/raw/master/itdoesnothing.rb
#

TEMPLATES_REPOSITORY = ENV['TEMPLATES_REPOSITORY'] || 'https://github.com/sampierson/rails-templates/raw/master'

templates = [
  'utils',
  'base+git',
  'debug',
  'rspec2',
  (RUBY_VERSION =~ /1.9/ ? 'cover_me' : 'rcov'),  # Test coverage measurement
  'cucumber+webrat',                              # Integration test framework: cucumber-capybara cucumber+webrat
  'compass+html5',                                # Templating/layout: haml compass+blueprint compass+html5
  'style',                                        # Customize layout
  'home_controller',                              # A simple controller around which we can wrap authentication
  'devise',                                       # Authentication
  'cancan',
  # 'jquery' - done already if we're using compass+html5
  'i18n',
  'jasmine',
  'page_specific_js_framework',
  'simple-navigation',
  'admin_base',
  'admin_users',
  'admin_settings',
  'spork'
]

deploy_strategy = ask "Deploy to Heroku [h], using Capistrano [c] or neither [n] ? [h]: "
deploy_strategy = 'h' if deploy_strategy.blank?
case deploy_strategy.first.downcase
when 'h':
  ENV['DEPLOY_STRATEGY'] = 'heroku'
  templates << 'herokuize'
when 'c':
  ENV['DEPLOY_STRATEGY'] = 'capistrano'
  templates << 'capistrano'
  default_deploy_host = "#{app_name}.com"
  deploy_host = ask "deploy_to_hostname [#{default_deploy_host}]: "
  ENV['CAPISTRANO_DEPLOY_HOST'] = deploy_host.blank? ? default_deploy_host : deploy_host
when 'n':
  ENV['DEPLOY_STRATEGY'] = 'none'
end

templates.each do |template|
  apply "#{TEMPLATES_REPOSITORY}/_#{template}.rb"
end

git_commit "Change logo to itdoesnothing" do
  gsub_file 'app/views/layouts/_header.html.haml', 'Logo', "It Does Nothing!"
end

run_and_commit "bundle package"
