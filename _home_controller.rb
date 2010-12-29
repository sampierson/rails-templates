git_commit('Create HomeController') do
  generate :controller, 'home index --no-test-framework --no-helper'

  # generate --template-engine=haml does not work
  remove_file 'app/views/home/index.html.erb'
  install_file 'app/views/home/index.html.haml'
  install_file 'spec/controllers/home_controller_spec.rb'
end

git_commit('Set root_path to HomeController#index') do
  gsub_file 'config/routes.rb', /# root :to => "welcome#index"/, "root :to => 'home#index'"  
end
