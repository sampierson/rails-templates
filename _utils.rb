
def git_commit(message, &block)
  yield if block_given?
  git :add => "."
  git :commit => "--quiet -m '#{message}'"
end

def run_and_commit(command, options={})
  commit_message = options[:message] ? "#{options[:message]}\n\n#{command}" : command
  git_commit(commit_message) do
    run command
  end
end

def bundle_install
  run 'bundle install --quiet'
end

# Copy (if we are using a local repository) or get (if we are using a remote repository) template file
def install_template(path)
  puts "  installing  #{path}"
  if TEMPLATES_REPOSITORY =~ /^https?:/
    get "#{TEMPLATES_REPOSITORY}/file_templates/#{path}", path
  else
    template "#{TEMPLATES_REPOSITORY}/file_templates/#{path}", path
  end
end
