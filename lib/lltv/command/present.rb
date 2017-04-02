require 'lltv/command'
require 'lltv/default'
require 'lltv/storage'
require 'lltv/processor'
require 'lltv/logger'
require 'fileutils'

module LLTV
  class Present < Command
    self.arguments = [
    ]

    def self.options
      [
        ['--file-store=/path/to/store', "If not set, lltv will assume #{Default.store_path}"],
        ['--sources-path=/path/to/sources', "If not set, lltv will assume #{Default.sources_path}"],
        ['--use-tmp-dir', "If set, lltv will use a temporary directory"],
      ].concat(super)
    end

    self.summary = <<-DESC

    DESC

    def initialize(argv)
      @file_store = argv.option('file-store') || Default.store_path
      @sources_path = argv.option('sources-path') || Default.sources_path
      @use_tmp_dir = argv.flag?('use-tmp-dir') || false
      super
    end

    def validate!
      super
    end

    def run
      Logger.log("Storage opened at #{@file_store}")
      change_directory do
        storage = Storage.new(@file_store)
        continue_info = storage.continue_info
        seektime = continue_info['seektime']
        part = continue_info['part']
        processor = Processor.new(@sources_path)
        should_process_next_file = processor.process(seektime, part)
        if should_process_next_file
          seektime = 0
          part += 1
        else
          seektime += Default.file_length
        end
        Logger.log("Storing continue info with seektime: #{seektime} at part: #{part}")
        storage.store({'seektime' => seektime, 'part' => part})
      end
    end

    def change_directory
      if @use_tmp_dir
        Dir.mktmpdir do |temp|
          Dir.chdir(temp) do
            yield
          end
        end
      else
        FileUtils.rm_rf(Default.workspace_path)
        Dir.mkdir(Default.workspace_path)
        Dir.chdir(Default.workspace_path) do
          yield
        end
      end
    end

  end
end
