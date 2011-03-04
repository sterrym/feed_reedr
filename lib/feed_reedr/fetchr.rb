require 'net/ftp'
require 'net/http'
require 'tmpdir'
require 'erb'

module FeedReedr
  class Fetchr
    def self.default_options
      @default_options ||= {
        :server_type   => nil,
        :server        => nil,
        :username      => nil,
        :password      => nil,
        :csv_basenames => [],
        :zip_basenames => [],
        :file_pattern  => "<%= basename %><%= date.strftime('%Y%m%d') %>.<%= suffix %>",
        :date          => Date.today
      }
    end

    attr_accessor :options, :csv_files, :zip_files

    def initialize options = {}
      @options = self.class.default_options.merge(options)
    end

    def csv_filenames
      options[:csv_basenames].nil? ? [] : options[:csv_basenames].map{|bn| filename_for(bn, options[:date], 'csv')}
    end

    def zip_filenames
      options[:zip_basenames].nil? ? [] : options[:zip_basenames].map{|bn| filename_for(bn, options[:date], 'zip')}
    end

    def fetch(tmp_dir = Dir::tmpdir)
      fetch_via_ftp(tmp_dir) if options[:server_type].downcase == 'ftp'
    end

    private
      def fetch_via_ftp(tmpdir)
        ftp = Net::FTP.new(options[:server], options[:username], options[:password])
        @csv_files = csv_filenames.map do |filename|
          local_file = File.join(tmpdir, filename)
          ftp.getbinaryfile(filename, local_file)
          local_file
        end
        unless @zip_filenames.nil?
          @zip_files = zip_filenames.map do |filename|
            local_file = File.join(tmpdir, filename)
            ftp.getbinaryfile(filename, local_file)
            local_file
          end
        end
        ftp.close
        true
      end

      def filename_for(basename, date, suffix)
        ERB.new(options[:file_pattern]).result(binding)
      end
  end
end