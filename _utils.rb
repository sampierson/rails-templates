
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

def bundle(command, options = {})
  default_options = { :quiet => true }
  actual_options = default_options.merge(options)
  options = actual_options.inject("") { |memo, kv| memo << " --#{kv.first}" if kv.last; memo }
  run "bundle #{command} #{options}"
end

# Install a file
# Use options[:method] if given (must be a Thor::Actions)
# else copy (if we are using a local repository) or get (if we are using a remote repository) file.
#
# if option :flavor is provided, that is prepended to the relative source path
#
def install_file(path, options = {})
  src_path = "#{TEMPLATES_REPOSITORY}/file_templates/#{options[:flavor]}/#{path}"
  method = options[:method] || (TEMPLATES_REPOSITORY =~ /^https?:/ ? :get : :copy_file)
  send method, src_path, path
end
