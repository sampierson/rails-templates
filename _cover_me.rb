gem 'cover_me', '>= 1.0.0.rc1'
run 'bundle install'

gsub_file 'spec/spec_helper.rb', /require 'rspec\/rails\n'/, <<-END
require 'rspec/rails'
require 'cover_me'
END

run 'bundle install'

generate :'cover_me:install'

append_file 'spec/spec_helper.rb', <<-'END'

CoverMe.config do |config|
  # where is your project's root:
  # c.project.root => "Rails.root" (default)

  # what files are you interested in coverage for:
  # c.file_pattern => /(#{CoverMe.config.project.root}\/app\/.+\.rb|#{CoverMe.config.project.root}\/lib\/.+\.rb)/ix (default)

  # where do you want the HTML generated:
  config.html_formatter.output_path = File.join(CoverMe.config.project.root, 'coverage')

  # what do you want to happen when it finishes:
  config.at_exit = Proc.new {
    if CoverMe.config.formatter == CoverMe::HtmlFormatter
      index = File.join(CoverMe.config.html_formatter.output_path, 'index.html')
      if File.exists?(index)
        `open #{index}`
      end
    end
  }
end
END

git :add => "."
git :commit => "-m 'add cover_me support'"
