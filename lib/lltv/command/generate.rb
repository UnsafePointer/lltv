require 'lltv/workspace'
require 'lltv/default'
require 'rmagick'
require 'fileutils'
require 'phash'

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
        file_name = ""
        Dir['*'].reject { |file| file.start_with?('.') }.sort.each_cons(2) do |file_name_1, file_name_2|
          hash_1 = Phash::Image.new(file_name_1)
          hash_2 = Phash::Image.new(file_name_2)
          result = hash_1.similarity(hash_2)
          Output.out("Comparisson result between #{file_name_1} and #{file_name_2}: #{result}")
          image_list << generate_image(file_name_1, delay)
          file_name = file_name_2
        end
        image_list << generate_image(file_name, delay)
        image_list.write(Default.file_name)
      end
    end

    private
    def generate_image(file_name, delay)
      image = Magick::Image.read(File.new(file_name)).first
      image.delay = delay
      image
    end
  end
end
