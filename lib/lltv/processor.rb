require 'streamio-ffmpeg'
require 'lltv/default'

module LLTV
  class Processor
    attr_reader :sources_path
    def initialize(sources_path)
      @sources_path = sources_path
    end

    def process(seektime, part)
      should_process_next_file = false
      movie = FFMPEG::Movie.new(sources_path + "part_#{part}.m4v")
      frames_per_second = Default.fps.to_f
      total_lenght_in_seconds = Default.file_length
      remaining = movie.duration - seektime
      if remaining < total_lenght_in_seconds
        total_lenght_in_seconds = remaining
        should_process_next_file = true
      end
      step = 1.to_f / frames_per_second
      total_steps = frames_per_second * total_lenght_in_seconds
      iter = seektime.to_f
      (0..total_steps).each do |step_number|
        file_name = 'screenshot_%.2d.jpeg' % step_number
        begin
          movie.screenshot(file_name, { seek_time: iter, resolution: Default.resolution, quality: Default.quality }, preserve_aspect_ratio: :width)
          iter += step.to_f

        rescue
        end
      end
      should_process_next_file
    end
  end
end
