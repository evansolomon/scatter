require 'thor'

module Scatter
  class CLI < Thor

    class_option :directory,
      :aliases => "-d",
      :type => :string,
      :default => "#{Dir.home}/.deploys",
      :desc => "Specify a deploys directory."

    class_option :project,
      :aliases => "-p",
      :type => :string,
      :desc => "Specify a project, defaults to current Git root's basename."

    class_option :shared,
      :aliases => "-s",
      :type => :string,
      :desc => "Use a deploy script in the __shared directory. The project name will automatically be passed as an argument"

    desc "deploy", "Run a deploy routine. This is the default task."
    def deploy
      run
    end
    default_task :deploy

    desc "cap COMMAND", "Run arbitrary Capistrano commands."
    def cap(*cmd)
      execute "cap", cmd
    end

    desc "execute COMMAND", "Run arbitrary commands."
    def execute(*cmd)
      run cmd.join ' '
    end

    desc "version", "Show version."
    map %w(-v --version) => :version
    def version
      say Scatter::VERSION
    end

    protected
    def git?
      `git rev-parse --is-inside-work-tree 2>/dev/null`.match "^true"
    end

    def project_name
      return options.project if options.project
      File.basename `git rev-parse --show-toplevel`.chomp if git?
    end

    def project_deploy_dir
      return "#{options.directory}/__shared" if options.shared
      "#{options.directory}/#{project_name}"
    end

    def capfile?
      File.exists? "#{project_deploy_dir}/Capfile"
    end

    def executable?
      deploy = "#{project_deploy_dir}/deploy"
      File.exists? deploy and File.executable? deploy
    end

    def generate_command
      return "./#{options.shared} #{project_name}" if options.shared
      return "./deploy" if executable?
      return "cap deploy" if capfile?
    end

    def run(command=nil)
      unless project_deploy_dir
        say "No deploy directory found"
        return
      end

      command = generate_command unless command

      unless command
        say "No deploy command found"
        return
      end

      system "cd #{project_deploy_dir} && #{command}"
    end

  end
end
