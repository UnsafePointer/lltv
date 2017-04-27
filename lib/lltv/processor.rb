require 'streamio-ffmpeg'
require 'lltv/default'
require 'lltv/settings'
require 'logger'
require 'fileutils'
require 'parallel'

module LLTV
  class Processor
    attr_reader :sources_path, :parallel
    def initialize(sources_path, parallel, verbose)
      @sources_path = sources_path
      @parallel = parallel
      Settings.setup_ffmpeg_logger() unless verbose
    end

    def process(seektime, part, errored)
      should_process_next_file = false
      movie = FFMPEG::Movie.new(sources_path + "part_#{part}.mp4")
      frames_per_second = Default.fps.to_f
      total_lenght_in_seconds = Default.file_length
      remaining = movie.duration - seektime
      if remaining.round(1) <= total_lenght_in_seconds
        total_lenght_in_seconds = remaining
        should_process_next_file = true
      end
      work(frames_per_second, total_lenght_in_seconds, seektime, movie, errored)
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
    def work(frames_per_second, total_lenght_in_seconds, seektime, movie, errored = false)
      total_frames = frames_per_second.to_f * total_lenght_in_seconds.to_f
      step = total_lenght_in_seconds.to_f / total_frames
      current_time_exec = Time.now
      work = lambda do |step_number|
        file_name = 'screenshot_%.2d.jpeg' % step_number
        seek_for_step = seektime.to_f + step_number * step.to_f
        current_time = Time.now
        begin
          resolution = errored ? Default.errored_resolution : Default.resolution
          quality = errored ? Default.errored_quality : Default.quality
          movie.screenshot(file_name, { seek_time: seek_for_step, resolution: resolution, quality: quality}, preserve_aspect_ratio: :width)
        rescue
        end
        finish_time = Time.now
        Output.out("Frame: #{file_name} composed in #{finish_time - current_time} seconds")
      end
      steps = Array(0..total_frames)
      if parallel
        Parallel.each(steps, &work)
      else
        steps.each(&work)
      end
      Output.out("Total execution time: #{Time.now - current_time_exec} seconds")
    end
  end
end
