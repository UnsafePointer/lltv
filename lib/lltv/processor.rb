require 'streamio-ffmpeg'
require 'lltv/default'
require 'lltv/settings'
require 'logger'
require 'fileutils'

module LLTV
  class Processor
    attr_reader :sources_path
    def initialize(sources_path, verbose)
      @sources_path = sources_path
      Settings.setup_ffmpeg_logger() unless verbose
    end

    def process(seektime, part)
      should_process_next_file = false
      movie = FFMPEG::Movie.new(sources_path + "part_#{part}.mp4")
      frames_per_second = Default.fps.to_f
      total_lenght_in_seconds = Default.file_length
      remaining = movie.duration - seektime
      if remaining.round(1) <= total_lenght_in_seconds
        total_lenght_in_seconds = remaining
        should_process_next_file = true
      end
      work(frames_per_second, total_lenght_in_seconds, seektime, movie)
      should_process_next_file
    end

    def process_random()
      part = rand(Default.total_parts + 1)
      movie = FFMPEG::Movie.new(sources_path + "part_#{part}.mp4")
      seektime = rand(movie.duration.to_i - 3)
      frames_per_second = Default.fps.to_f
      total_lenght_in_seconds = Default.file_length
      work(frames_per_second, total_lenght_in_seconds, seektime, movie)
    end

    private
    def work(frames_per_second, total_lenght_in_seconds, seektime, movie)
      total_frames = frames_per_second.to_f * total_lenght_in_seconds.to_f
      step = total_lenght_in_seconds.to_f / total_frames
      iter = seektime.to_f
      (0..total_frames).each do |step_number|
        file_name = 'screenshot_%.2d.jpeg' % step_number
        current_time = Time.now
        begin
          movie.screenshot(file_name, { seek_time: iter, resolution: Default.resolution, quality: Default.quality }, preserve_aspect_ratio: :width)
          iter += step.to_f
        rescue
        end
        finish_time = Time.now
        Output.out("Frame: #{file_name} composed in #{finish_time - current_time} seconds")
      end
    end
  end
end
