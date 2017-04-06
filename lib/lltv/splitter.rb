require 'lltv/output'

module LLTV
  class Splitter
    attr_reader :file_path, :length, :start

    def initialize(file_path, length, start)
      @file_path = file_path
      @length = length
      @start = start
      Settings.setup_ffmpeg_logger()
    end

    def split()
      Output.out("Splitter started with file_path: #{file_path}, length: #{length}")
      movie = FFMPEG::Movie.new(file_path)
      parts = (movie.duration / length).to_i
      parts += 1 if parts * length < movie.duration
      parts -= start
      parts.times do |i|
        part = i + start
        current_time = Time.now
        ss = part * length
        movie.transcode("part_#{part}.mp4", %W(-ss #{format(ss)} -t #{format(length)}))
        finish_time = Time.now
        Output.out("File: part_#{part}.mp4 splitted in #{finish_time - current_time} seconds")
      end
    end

    def format(seconds)
      Time.at(seconds).utc.strftime("%H:%M:%S")
    end
  end
end
