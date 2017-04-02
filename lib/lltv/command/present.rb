require 'lltv/command'
require 'lltv/default'
require 'lltv/storage'
require 'lltv/processor'

module LLTV
  class Present < Command
    self.arguments = [
    ]

    def self.options
      [
        ['--file-store=/path/to/store', "If not set, lltv will assume #{Default.store_path}"],
        ['--sources-path=/path/to/sources', "If not set, lltv will assume #{Default.sources_path}"]
      ].concat(super)
    end

    self.summary = <<-DESC
      
    DESC

    def initialize(argv)
      @file_store = argv.option('file-store')
      @file_store ||= Default.store_path
      @sources_path = argv.option('sources-path')
      @sources_path ||= Default.sources_path
      super
    end

    def validate!
      super
    end

    def run
      storage = Storage.new(@file_store)
      continue_info = storage.continue_info
      seektime = continue_info['time']
      part = continue_info['part']
      processor = Processor.new(@sources_path)
      processor.process(seektime, part)
    end
  end
end