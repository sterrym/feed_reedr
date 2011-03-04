require File.join(File.dirname(__FILE__), 'feed_reedr', 'fetchr')
require File.join(File.dirname(__FILE__), 'feed_reedr', 'reedr')
require File.join(File.dirname(__FILE__), 'feed_reedr', 'feedr')

module FeedReedr
  class Base
    attr_accessor :config, :for_date

    class << self
      def load_yaml
        config = YAML.load(File.read(File.join(root_path, 'config','feed.yml')))[::Rails.env] if const_defined?('Rails')
        config ||= YAML.load(File.read(File.join(root_path, 'config', 'feed.yml')))
        raise NotConfigured.new("Unable to load configuration from feed.yml. Is it set up?") if config.nil?
        config
      end
      def root_path
        ::Rails.root
      end
    end

    def initialize
      @config = self.class.load_yaml
    end
    
    def fetchr
      @fetchr ||= FeedReedr::Fetchr.new({
        :server_type   => config["server_type"],
        :server        => config["server"],
        :username      => config["username"],
        :password      => config["password"],
        :csv_basenames => config["csv_basenames"],
        :zip_basenames => config["zip_basenames"],
        :file_pattern  => config["file_pattern"],
        :date          => for_date || Date.today
      })
    end
  end
end
