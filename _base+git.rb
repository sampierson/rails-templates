run "echo TODO > README"

git :init
run "find . -type d -empty | while read dir ; do touch $dir/.gitkeep ; done"
if File.exist?('.gitignore')
  puts "Appending to .gitignore"
  File.open('.gitignore', 'a') do |f|
    f.puts <<-EOF
db/schema.rb
.idea
!.gitignore
    EOF
  end
else
  file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
db/*.sqlite3
db/schema.rb
.idea
!.gitignore
  END
end

git :add => "."
git :commit => "-m 'Virgin Rails #{Rails::VERSION::STRING} application'"
