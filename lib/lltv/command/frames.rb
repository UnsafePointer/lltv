require 'lltv/command'
require 'lltv/default'
require 'lltv/storage'
require 'lltv/processor'
require 'lltv/output'
require 'lltv/workspace'
require 'fileutils'
require 'tmpdir'

module LLTV
  class Frames < Command
    self.arguments = [
    ]

    def self.options
      [
        ['--sources-path=/path/to/sources', "If not set, lltv will assume #{Default.sources_path}"],
      ].concat(super)
    end

    self.summary = <<-DESC
      Retrieve GIF frames
    DESC

    def initialize(argv)
      @sources_path = argv.option('sources-path') || Default.sources_path
      super
    end

    def validate!
      super
    end

    def run
      FileUtils.rm_rf(Default.workspace_path)
      Workspace.change_directory do
        Output.out("Storage opened at #{Default.store_path}")
        storage = Storage.new(Default.store_path)
        continue_info = storage.continue_info
        seektime = continue_info['seektime']
        part = continue_info['part']
        processor = Processor.new(@sources_path)
        should_process_next_file = processor.process(seektime, part)
        Output.out("Storing continue info with seektime: #{seektime} at part: #{part} with should_process_next_file: #{should_process_next_file}")
        storage.store({'seektime' => seektime, 'part' => part, 'should_process_next_file' => should_process_next_file})
      end
    end

  end
end
