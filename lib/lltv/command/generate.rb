require 'lltv/workspace'
require 'lltv/default'
require 'rmagick'

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
        image_list = Magick::ImageList.new
        lenght = Default.file_length
        fps = Default.fps
        delay = lenght.to_f / fps.to_f
        Dir['*'].reject { |file| file.start_with?('.') }.each do |file_name|
          image = Magick::Image.read(File.new(file_name)).first
          image.delay = delay
          image_list << image
        end
        image_list.write(Default.file_name)
      end
    end

  end
end