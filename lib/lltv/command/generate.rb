require 'lltv/workspace'
require 'lltv/default'
require 'rmagick'
require 'fileutils'

module LLTV
  class Generate < Command
    self.arguments = [
    ]

    def self.options
      [
      ].concat(super)
    end

    self.summary = <<-DESC
      Generate GIF file
    DESC

    def initialize(argv)
      super
    end

    def validate!
      super
    end

    def run
      Workspace.change_directory do
        FileUtils.rm_rf(Default.file_name)
        image_list = Magick::ImageList.new
        length = Default.file_length
        fps = Default.fps
        total_frames = length.to_f * fps.to_f
        delay = length.to_f / total_frames.to_f
        Dir['*'].reject { |file| file.start_with?('.') }.sort.each do |file_name|
          image = Magick::Image.read(File.new(file_name)).first
          image.delay = delay
          image_list << image
        end
        image_list.write(Default.file_name)
      end
    end

  end
end
