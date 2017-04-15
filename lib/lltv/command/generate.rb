require 'lltv/workspace'
require 'lltv/default'
require 'rmagick'
require 'fileutils'
require 'lltv/image'
require 'lltv/output'

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
        length = Default.file_length
        fps = Default.fps
        total_frames = length.to_f * fps.to_f
        delay = length.to_f / total_frames.to_f
        last_image = nil
        last_image_q = nil
        last_image_histogram = {}
        Dir['*'].reject { |file| file.start_with?('.') }.sort.each_cons(2) do |file_name_1, file_name_2|
          image_1 = last_image
          image_1 ||= generate_image(file_name_1, delay)
          image_2 = generate_image(file_name_2, delay)
          q_1 = last_image_q
          q_1 ||= image_1.quantize(Default.number_of_colors, Magick::RGBColorspace)
          q_2 = image_2.quantize(Default.number_of_colors, Magick::RGBColorspace)
          colors = ['red', 'green', 'blue']
          result = 0
          colors.each do |color|
            histogram_1 = last_image_histogram[color]
            histogram_1 ||= q_1.specific_color_histogram(color)
            histogram_2 = q_2.specific_color_histogram(color)
            Default.histogram_bucket_size.times do |time|
              result += (histogram_1[time] - histogram_2[time]).abs
            end
            last_image_histogram[color] = histogram_2
          end
          Output.out("Comparison result between #{file_name_1} and #{file_name_2}: #{result}")
          image_1.delay = delay
          last_image = image_2
          last_image_q = q_2
        end
        delay_param = "%.2f" % delay
        `convert -delay #{delay} -loop 0 screenshot_*.jpeg love_live.gif`
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
