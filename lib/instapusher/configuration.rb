require 'yaml'

# used to read api_key
module Instapusher
  module Configuration
    extend self
    @_settings = {}
    attr_reader :_settings

    def load(debug = false, filename=nil)
      filename ||= File.join(ENV['HOME'], '.instapusher')

      unless File.exist? filename
        File.new(filename, File::CREAT|File::TRUNC|File::RDWR, 0644).close
      end

      @_settings = YAML::load_file(filename) || {}

      if debug
        puts @_settings.inspect
      end
    end

    def ask_for_api_key
      puts "Enter your Instapusher API key:"
      api_key = ask
      api_key
    end

    def ask_for_and_write_api_key
      api_key = ask_for_api_key
      instapusher_config = {"api_key" => api_key}
      File.open(File.join(Dir.home, ".instapusher"), "w") do |file|
        file.write instapusher_config.to_yaml
      end
    end

    def ask
      $stdin.gets.to_s.strip
    end

    def method_missing(name, *args, &block)
      self.load
      @_settings[name.to_s]
    end
  end
end
