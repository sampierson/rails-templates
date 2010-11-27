def git_commit(message, &block)
  yield if block_given?
  git :add => "."
  git :commit => "--quiet -m '#{message}'"
end
  
def bundle_install
  run 'bundle install --local --quiet'
end

# Copy (if we are using a local repository) or get (if we are using a remote repository) template file
def install_template(path)
  if TEMPLATES_REPOSITORY =~ /^https?:/
    get "#{TEMPLATES_REPOSITORY}/file_templates/#{path}", path
  else
    template "#{TEMPLATES_REPOSITORY}/file_templates/#{path}", path
  end
end

git_commit "Virgin Rails #{Rails::VERSION::STRING} application" do

  run "echo TODO > README"
  remove_file 'public/index.html'

  git :init
  run "find . -type d -empty | while read dir ; do touch $dir/.gitkeep ; done"
  if File.exist?('.gitignore')
    append_file ".gitignore", <<-END
db/schema.rb
.idea
!.gitignore
    END
  else
    file ".gitignore", <<-END
.DS_Store
/log
/tmp
/db/*.sqlite3
/db/schema.rb
.idea
!.gitignore
    END
  end
end
