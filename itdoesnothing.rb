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
}.each do |template|
  apply "#{TEMPLATES_REPOSITORY}/_#{template}.rb"
end
