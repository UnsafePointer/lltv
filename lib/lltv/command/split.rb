require 'lltv/command'
require 'lltv/output'
require 'lltv/splitter'
require 'lltv/default'
require 'lltv/workspace'

module LLTV
  class Split < Command
    self.arguments = [
      CLAide::Argument.new('file_path', true),
    ]

    def self.options
      [
        ['--length=n', "Split the file in parts of `n` seconds length each, as much as possible. Default is 10"],
        ['--start=i', "Processing will start at part `i`. Default is 0"],
      ].concat(super)
    end

    self.summary = <<-DESC
      Split file at `file_path`.
    DESC

    def initialize(argv)
      @file_path = argv.shift_argument
      @length = argv.option('length')
      @length ||= Default.part_length
      @length = @length.to_i
      @start = argv.option('start').to_i
      super
    end

    def validate!
      super
      help! "`file_path` argument is required" if @file_path.nil?
      help! "File doesn't exist" unless File.exist?(@file_path)
    end

    def run
      FileUtils.rm_rf(Default.workspace_path)
      Workspace.change_directory do
        splitter = Splitter.new(@file_path, @length, @start)
        splitter.split
      end
    end
  end
end
