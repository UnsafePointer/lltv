require 'lltv/output'

module LLTV
  class Splitter
    attr_reader :file_path, :length, :start, :mark

    def initialize(file_path, length, start, mark = 0)
      @file_path = file_path
      @length = length
      @start = start
      @mark = mark
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
        part_name = part + mark
        movie.transcode("part_%.3d.mp4" % part_name, %W(-ss #{format(ss)} -t #{format(length)}))
        finish_time = Time.now
        Output.out("File: part_%.3d.mp4 splitted in #{finish_time - current_time} seconds" % part_name)
      end
    end

    def format(seconds)
      Time.at(seconds).utc.strftime("%H:%M:%S")
    end
  end
end
