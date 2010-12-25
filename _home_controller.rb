git_commit('Created HomeController#index') do
  generate :controller, 'home index --no-test-framework --no-helper'

  # generate --template-engine=haml does not work
  remove_file 'app/views/home/index.html.erb'
  install_template 'app/views/home/index.html.haml'
  create_file 'spec/controllers/home_controller_spec.rb', <<-EOF
require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "should render" do
      get :index
      response.should render_template('home/index')
    end
  end
end
  EOF
end

git_commit('Set root_path to HomeController#index') do
  gsub_file 'config/routes.rb', /# root :to => "welcome#index"/, "root :to => 'home#index'"  
end
