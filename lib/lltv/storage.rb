require 'yaml'

module LLTV
  class Storage
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def continue_info
      continue_info = YAML.load_file(path) if File.exist? path
      continue_info ||= { 'seektime' => 0, 'part' => 1, 'should_process_next_file' => false }
    end

    def store(continue_info)
      File.write(path, continue_info.to_yaml)
    end
  end
end
