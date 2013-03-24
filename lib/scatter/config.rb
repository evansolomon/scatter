require 'yaml'

module Scatter
  class Config
    CONFIG_FILE = "#{Dir.home}/.scatterconfig"
    DEFAULTS = {'directory' => "#{Dir.home}/.deploys"}

    def self.parse
      return DEFAULTS unless File.exists? CONFIG_FILE

      begin
        return DEFAULTS.merge YAML.load(File.read CONFIG_FILE)
      rescue
        abort "There was a problem parsing #{CONFIG_FILE}, it should be valid YAML"
      end
    end

    def self.get(key=nil)
      config = self.parse
      key ? config[key] : config
    end
  end
end
