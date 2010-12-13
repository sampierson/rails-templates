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
