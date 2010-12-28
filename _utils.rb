
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
#
# Options:
#
# :method => Thor::Action to use to install, e.g. :get, :copy_file or :template
#            Default is :get (for http repository) or :copy_file (local repository)
# :source => Use this source file (relative to file_templates/)
# :flavor => Subdir of file_templates to look for source file of same name as dest file (cannot be used with :source)
#
def install_file(path, options = {})
  source_path = "#{TEMPLATES_REPOSITORY}/file_templates/" + (options[:source] || "#{options[:flavor]}/#{path}")
  method = options.delete(:method) || (TEMPLATES_REPOSITORY =~ /^https?:/ ? :get : :copy_file)
  send method, source_path, path
end
