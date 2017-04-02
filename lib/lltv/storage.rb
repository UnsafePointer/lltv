module LLTV
  class Storage
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def continue_info
      continue_info = File.read(path) if File.exist? path
      continue_info ||= { 'time' => 0, 'part' => 1 }
    end
  end
end