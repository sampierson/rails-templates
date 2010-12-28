debug_gem = RUBY_VERSION =~ /1.9/ ? 'ruby-debug19' : 'ruby-debug'

git_commit "Bundle #{debug_gem} gem" do
  gem debug_gem, :group => [:development, :test]
  bundle :install
end
