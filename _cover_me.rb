git_commit("bundle cover_me gem") do
  gem 'cover_me', :group => [:development, :test]
  bundle :install  
end

git_commit "rails generate cover_me:install" do
  generate :'cover_me:install'
end

git_commit "Configure cover_me" do

  insert_into_file('lib/tasks/cover_me.rake', :after => "task :report do\n    require 'cover_me'\n") do
    <<-'END'

    CoverMe.config do |config|
      # where is your project's root:
      # c.project.root => "Rails.root" (default)

      # what files are you interested in coverage for:
      # c.file_pattern => /(#{CoverMe.config.project.root}\/app\/.+\.rb|#{CoverMe.config.project.root}\/lib\/.+\.rb)/ix (default)

      # where do you want the HTML generated:
      config.html_formatter.output_path = File.join(CoverMe.config.project.root, 'coverage')

      # what do you want to happen when it finishes:
      config.at_exit = Proc.new {
      #   if CoverMe.config.formatter == CoverMe::HtmlFormatter
      #     index = File.join(CoverMe.config.html_formatter.output_path, 'index.html')
      #     if File.exists?(index)
      #       `open #{index}`
      #     end
      #   end
      }
    end

    END
  end

  append_file '.gitignore', <<-'END'
/coverage.data
/coverage
  END
end
