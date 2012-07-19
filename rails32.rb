#
# Rails template to create a Rails 3.2 application
#
# USAGE:
##
#   rvm use --create ruby-1.9.3-p194@<name>     # or Ruby of your choice
#   gem install bundler --pre --no-rdoc --no-ri  # Until bundler reaches 1.2.0
#   gem install rails --no-rdoc --no-ri
#   rails new <name> --skip-test-unit --skip-bundle --template=<url/or/path/to/this/file>
#

def git_commit(message, &block)
  yield if block_given?
  git :add => '.'
  git :commit => "--quiet --message '#{message}'"
end

def bundle(command, options = {})
  default_options = { :quiet => true, :local => false }
  actual_options = default_options.merge(options)
  options = actual_options.inject('') { |memo, kv| memo << " --#{kv.first}" if kv.last; memo }
  run "bundle #{command} #{options}"
end

rvm_ruby = `rvm current`.chomp

if rvm_ruby == 'system'
  puts "Please select an RVM ruby and create and 'use' a gemset before using this template"
  exit 1
end

git_commit "Virgin Rails #{Rails::VERSION::STRING} application" do
  git :init
end

run 'mv config/database.yml tmp'

git_commit "Remove and Gitignore database.yml" do
  git :rm => 'config/database.yml'
  append_file '.gitignore', <<-END

/config/database.yml

# Mac OS X Finder
.DS_Store
  END
end

say "Fix up database.yml:
Removed username and password entries, falling back on PostgreSQL feature
wherby it will use the current user."
gsub_file 'tmp/database.yml',
          /^  username: #{@app_name}\n/,
          ''
gsub_file 'tmp/database.yml',
          /^  password:\n/,
          ''
run 'mv tmp/database.yml config'

git_commit "Add .rvmrc" do
  create_file '.rvmrc', "rvm use --create #{rvm_ruby}\n"
end

git_commit "Set ruby version to #{RUBY_VERSION} in Gemfile" do
  insert_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", :after => "source 'https://rubygems.org'\n"
end

git_commit "Overwrite README" do
  run 'echo TODO > README'
end

git_commit "Remove public/index.html" do
  git :rm => 'public/index.html'
end

git_commit "Gitignore .idea and .DS_Store" do
  append_file '.gitignore', <<-END

# RubyMine
.idea

# Mac OS X Finder
.DS_Store
  END
end

git_commit "Add groups to Gemfile" do
  append_file 'Gemfile', <<-END

group :development do
end

group :development, :test do
end

group :test do
end

# Gems to exclude when using Linux
# Use: bundle install --without osxtest
group :osxtest do
end
  END
end

git_commit "Bundle haml, haml-rails gems" do
  insert_into_file 'Gemfile', "gem 'haml'\n", :before => "\n# Bundle edge Rails"
  insert_into_file 'Gemfile', "  gem 'haml-rails'\n", :after => "group :development do\n"
  bundle :install
end

git_commit "Use HAML template engine" do
  insert_into_file 'config/application.rb', :before => /^  end\nend/ do
    <<-EOF

    config.generators do |g|
      g.template_engine :haml
    end
    EOF
  end
end

git_commit "Bundle bootstrap-sass" do
  insert_into_file 'Gemfile', "  gem 'bootstrap-sass'\n", :after => "gem 'uglifier', '>= 1.0.3'\n"
  bundle :install
end

git_commit "Bundle simple_form" do
  insert_into_file 'Gemfile', "gem 'simple_form'\n", :before => "\n# Bundle edge Rails"
  bundle :install
end

git_commit "rails generate simple_form:install --bootstrap --template_engine=haml" do
  generate 'simple_form:install --bootstrap --template_engine=haml'
end

git_commit "Bundle page_specific_js" do
  insert_into_file 'Gemfile', "gem 'page_specific_js'\n", :before => "\n# Bundle edge Rails"
  bundle :install
end

git_commit "Bundle meta-tags" do
  insert_into_file 'Gemfile', "gem 'meta-tags', :require => 'meta_tags'\n", :before => "\n# Bundle edge Rails"
  bundle :install
end

git_commit "Set defaults for generators" do
  insert_into_file 'config/application.rb', :after => "g.template_engine :haml\n" do
    <<-EOF
      g.assets false
      g.stylesheets false
      g.view_specs false
      g.helper false
      g.helper_specs false
    EOF
  end
end

git_commit "quiet_assets patch" do
  create_file 'config/initializers/quiet_assets.rb' do
    <<-END
if Rails.env.development?
  Rails.application.assets.logger = Logger.new('/dev/null')
  Rails::Rack::Logger.class_eval do
    def call_with_quiet_assets(env)
      previous_level = Rails.logger.level
      Rails.logger.level = Logger::ERROR if env['PATH_INFO'] =~ %r{^/assets/}
      call_without_quiet_assets(env)
    ensure
      Rails.logger.level = previous_level
    end
    alias_method_chain :call, :quiet_assets
  end
end
    END
  end
end

git_commit "use thin webserver" do
  insert_into_file 'Gemfile', "gem 'thin'\n", :before => "\n# Bundle edge Rails"
  bundle :install
end

# TODO
#
# layout
# page_specific_js
# meta-tags
# quiet-assets?
# rake tabs
# rake deploy

# TESTING AND DEBUGGING

# rspec-rails
# faker
# shoulda-matchers
# cucumber/capybara/cucumber-rails-training-wheels
# debugger
# autotest-standalone

# devise

git_commit "HomeController#index" do
  generate 'controller home index'
  insert_into_file 'config/routes.rb', "  root :to => 'home#index'\n", :after => /Application\.routes\.draw do\n/
end