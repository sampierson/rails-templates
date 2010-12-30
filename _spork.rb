git_commit "Bundle spork gem" do
  gem 'spork', :group => [:development, :test]
end

git_commit "Configure spec_helper and .rspec for spork" do
  spec_file = 'spec/spec_helper.rb'
  gsub_file spec_file, /^/, "  "
  prepend_file spec_file, <<-EOF
require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

    EOF

  append_file spec_file, <<-EOF
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

  EOF

  replace_file_with '.rspec', "--colour --drb\n"
end
