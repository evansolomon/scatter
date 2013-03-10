require 'thor'
require 'json'

module Scatter
  class Config < Thor
    CONFIG_FILE = "#{Dir.home}/.scatterconfig"

    desc "alias FROM TO", "Alias a scatter command."
    def alias(from, to)
      say "Aliasing `scatter #{from}` to `scatter #{to}`"

      settings = read
      settings["aliases"] ||= {}
      settings["aliases"][from] = to
      save settings
    end

    desc "deploys PATH", "Set a default deploys directory."
    def deploys(path)
      path = File.expand_path path
      say "Setting default deploys directory to #{path}"
      settings = read
      settings['directory'] = path
      save settings
    end

    no_tasks do
      def read
        setup
        return {} unless @settings.length > 0

        begin
          JSON.load @settings
        rescue
          {}
        end
      end
    end

    protected
    def setup
      File.open CONFIG_FILE, "w+" unless File.exists? CONFIG_FILE
      @settings = IO.read CONFIG_FILE
    end

    def save(settings)
      setup
      File.open(CONFIG_FILE, "w+") do |f|
        f.write JSON.pretty_generate(settings)
      end
    end
  end
end
