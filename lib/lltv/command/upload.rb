require 'lltv/workspace'
require 'lltv/default'
require 'lltv/bot'

module LLTV
  class Upload < Command
    self.arguments = [
    ]

    def self.options
      [
      ].concat(super)
    end

    self.summary = <<-DESC
      Upload GIF file
    DESC

    def initialize(argv)
      super
    end

    def validate!
      super
    end

    def run
      Workspace.change_directory do
        Logger.log("Storage opened at #{Default.store_path}")
        storage = Storage.new(Default.store_path)
        continue_info = storage.continue_info
        seektime = continue_info['seektime']
        part = continue_info['part']
        bot = Bot.new()
        bot.post
        if continue_info['should_process_next_file']
          seektime = 0
          part += 1
        else
          seektime += Default.file_length
        end
        Logger.log("Storing continue info with seektime: #{seektime} at part: #{part} with should_process_next_file: false")
        storage.store({'seektime' => seektime, 'part' => part, 'should_process_next_file' => false})
      end
    end

  end
end
