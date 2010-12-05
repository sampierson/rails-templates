git_commit("Remove prototype") do
  # remove prototype if it is present
  %w(controls.js dragdrop.js effects.js prototype.js).each do |js|
    file = "public/javascripts/#{js}"
    git(:rm => file) if File.exist?(file)
  end
end

# Install jQuery
@jquery_version = "1.4.4"
git_commit("Install jQuery") do
  get "http://code.jquery.com/jquery-#{@jquery_version}.js",     "public/javascripts/jquery-#{@jquery_version}.js"
  get "http://code.jquery.com/jquery-#{@jquery_version}.min.js", "public/javascripts/jquery-#{@jquery_version}.min.js"
end

git_commit("Install jquery-ujs as a submodule") do
  git(:submodule => 'add git://github.com/rails/jquery-ujs.git public/javascripts/jquery-ujs')
end

git_commit("Configure javascript_include_tag") do
  inject_into_file 'config/environments/development.rb', :before => /^end\n/ do
    "\n  config.action_view.javascript_expansions[:defaults] = ['jquery-1.4.4', 'jquery-ujs/src/rails']\n"
  end
  inject_into_file 'config/environments/production.rb', :before => /^end\n/ do
    "\n  config.action_view.javascript_expansions[:defaults] = ['jquery-1.4.4.min', 'jquery-ujs/src/rails']\n"
  end
end
