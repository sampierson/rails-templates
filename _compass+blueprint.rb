git_commit("[Compass] bundle compass gem") do
  gem "haml"
  gem "compass"
  bundle :install
end

command = 'compass init rails . --using blueprint --sass-dir app/stylesheets --css-dir public/stylesheets'
run_and_commit(command, :message => "[Compass] #{command}")

git_commit('[Compass] Changes suggested by compass init') do
  gsub_file 'app/views/layouts/application.html.haml', /    = stylesheet_link_tag 'application'\n/, <<-EOF
    = stylesheet_link_tag 'screen', 'application', :media => 'screen, projection'
    = stylesheet_link_tag 'print', :media => 'print'
    /[if lt IE 8]
      = stylesheet_link_tag 'ie',   :media => 'screen, projection'

  EOF
end
