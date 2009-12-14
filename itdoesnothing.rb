run "echo TODO > README"
git :init
run "find . -type d -empty | while read dir ; do touch $dir/.gitignore ; done"
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
db/*.sqlite3
.idea
!.gitignore
END
git :add => "."
git :commit => "-m 'virgin Rails application'"
