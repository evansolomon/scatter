require 'thor'
require 'scatter/config'

module Scatter
  class CLI < Thor

    class_option :directory,
      :aliases => "-d",
      :type => :string,
      :default => Config.get('directory'),
      :desc => "Specify a deploys directory."

    class_option :project,
      :aliases => "-p",
      :type => :string,
      :desc => "Specify a project path, defaults to current Git repository root."

    class_option :shared,
      :aliases => "-s",
      :type => :string,
      :desc => "Use a deploy script in the __shared directory. The project path will automatically be passed as an argument"

    desc "deploy", "Run a deploy routine. This is the default task."
    def deploy
      run
    end
    default_task :deploy

    desc "cap COMMAND", "Run arbitrary Capistrano commands."
    def cap(*cmd)
      exec "cap", cmd
    end

    desc "exec COMMAND", "Run arbitrary commands."
    def exec(*cmd)
      run cmd.join ' '
    end

    desc "version", "Show version."
    map %w(-v --version) => :version
    def version
      say Scatter::VERSION
    end

    no_tasks do
      # Process aliases
      def method_missing(method, *args)
        aliases  = Config.get 'aliases'
        _method  = method.to_s

        return super unless aliases.has_key?(_method) and aliases[_method].is_a?(String)
        system "scatter #{aliases[_method]}"
      end

      def git?
        unless system "which git >/dev/null 2>&1"
          abort "Scatter requires Git if you want it to find projects automatically"
        end

        `git rev-parse --is-inside-work-tree 2>/dev/null`.match "^true"
      end

      def project_path
        if options.project
          File.expand_path options.project
        elsif git?
          `git rev-parse --show-toplevel`.chomp
        end
      end

      def project_deploy_dir
        if options.shared
          "#{options.directory}/__shared"
        elsif project_path
          "#{options.directory}/#{File.basename project_path}"
        end
      end

      def capfile?
        File.exists? "#{project_deploy_dir}/Capfile"
      end

      def executable?
        deploy = "#{project_deploy_dir}/deploy"
        return false unless File.exists? deploy

        unless File.executable? deploy
          abort "It looks like you have a deploy file, but it's not executable. Try something like: chmod +x #{deploy}"
        end

        return true
      end

      def generate_command
        return "./#{options.shared} #{project_path}" if options.shared
        return "./deploy #{project_path}" if executable?
        return "cap deploy" if capfile?
      end

      def run(command=nil)
        abort "No deploy directory found" unless project_deploy_dir
        abort "No deploy command found"   unless command ||= generate_command

        system "cd #{project_deploy_dir} && #{command}"
      end

    end
  end
end
