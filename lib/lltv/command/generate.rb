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
        last_image_histogram = {}
        skipping_end_of_file = false
        skipping_beginning_of_file = false
        Dir['*'].reject { |file| file.start_with?('.') }.sort.each_cons(2).to_a.each_with_index do |(file_name_1, file_name_2), i|
          if skipping_beginning_of_file
            i.times do |time|
              FileUtils.rm_rf("screenshot_%.2d.jpeg" % time)
            end
            skipping_beginning_of_file = false
          end
          if skipping_end_of_file
            FileUtils.rm_rf(file_name_1)
            FileUtils.rm_rf(file_name_2)
            next
          end
          image_1 = last_image
          image_1 ||= generate_image(file_name_1, delay)
          image_2 = generate_image(file_name_2, delay)
          colors = ['red', 'green', 'blue']
          result = 0
          colors.each do |color|
            histogram_1 = last_image_histogram[color]
            histogram_1 ||= image_1.specific_color_histogram(color)
            histogram_2 = image_2.specific_color_histogram(color)
            Default.histogram_bucket_size.times do |time|
              result += (histogram_1[time] - histogram_2[time]).abs
            end
            last_image_histogram[color] = histogram_2
          end
          Output.out("Comparison result between #{file_name_1} and #{file_name_2}: #{result}")
          image_1.delay = delay
          last_image = image_2
          remaining_frames = total_frames.to_i - i
          should_skip_frames_end_of_file = remaining_frames <= Default.remaining_frames_skip
          should_skip_frames_beginning_of_file = remaining_frames >= total_frames - Default.remaining_frames_skip
          if result > Default.scene_change_tolerance && (should_skip_frames_end_of_file || should_skip_frames_beginning_of_file)
            Output.out("Skipping remaining frames: #{remaining_frames}") if should_skip_frames_end_of_file
            Output.out("Skipping beginning frames: #{i + 1}") if should_skip_frames_beginning_of_file
            skipping_end_of_file = true if should_skip_frames_end_of_file
            skipping_beginning_of_file = true if should_skip_frames_beginning_of_file
            FileUtils.rm_rf(file_name_2) if should_skip_frames_end_of_file
          end
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
