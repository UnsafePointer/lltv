require 'streamio-ffmpeg'
require 'lltv/default'
require 'lltv/settings'
require 'logger'
require 'fileutils'

module LLTV
  class Processor
    attr_reader :sources_path
    def initialize(sources_path)
      @sources_path = sources_path
      Settings.setup_ffmpeg_logger()
    end

    def process(seektime, part)
      should_process_next_file = false
      movie = FFMPEG::Movie.new(sources_path + "part_#{part}.mp4")
      frames_per_second = Default.fps.to_f
      total_lenght_in_seconds = Default.file_length
      remaining = movie.duration - seektime
      if remaining < total_lenght_in_seconds
        total_lenght_in_seconds = remaining
        should_process_next_file = true
      end
      total_frames = frames_per_second.to_f * total_lenght_in_seconds.to_f
      step = total_lenght_in_seconds.to_f / total_frames
      iter = seektime.to_f
      (0..total_frames).each do |step_number|
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
