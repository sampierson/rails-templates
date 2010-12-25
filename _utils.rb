
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
def install_template(path, options)
  src_path = "#{TEMPLATES_REPOSITORY}/file_templates/#{options[:flavor]}/#{path}"
  puts "  installing #{path}"
  method = TEMPLATES_REPOSITORY =~ /^https?:/ ? :get : :template
  send method, src_path, path
end
