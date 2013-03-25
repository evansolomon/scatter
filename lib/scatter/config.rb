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

    def self.save(options)
      File.open(CONFIG_FILE, 'w') do |f|
        f.write options.to_yaml
      end
    end

    def self.set(key, value)
      config = get
      config[key] = value
      save config
    end

    def self.show(key=nil)
      if key
        value = get[key]
      else
        value = get
      end

      value.to_yaml
    end
  end
end
