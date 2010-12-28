require File.join(File.dirname(__FILE__), '_utils')

git_commit "Install page-specific JavaScript framework" do
  remove_file 'public/javascripts/application.js'
  empty_directory  "public/javascripts/#{app_name}"
  install_file "public/javascripts/#{app_name}/#{app_name}.js", :source => "public/javascripts/app_name/app_name.js", :method => :template

  insert_into_file 'app/helpers/application_helper.rb', :before => "\nend", do
    <<-EOF

  def javascript_include_tags
    js_files = %w{
      rails
      plugins
      #{app_name}/#{app_name}
    } + Dir.glob("\#{Rails.root}/public/javascripts/#{app_name}/pages/**/*.js").map { |file| file.gsub(/^\#{Rails.root}\\/public/, '') }
    javascript_include_tag js_files, :cache => '#{app_name}-javascripts'
  end
    EOF
  end

  gsub_file 'app/views/layouts/_javascripts.html.haml',
    /^= javascript_include_tag 'rails', 'plugins', 'application'$/,
    "= javascript_include_tags"
end
