require 'lltv/output'

module LLTV
  class Splitter
    attr_reader :file_path, :length

    def initialize(file_path, length)
      @file_path = file_path
      @length = length
      Settings.setup_ffmpeg_logger()
    end

    def split()
      Output.out("Splitter started with file_path: #{file_path}, length: #{length}")
      movie = FFMPEG::Movie.new(file_path)
      parts = (movie.duration / length).to_i
      parts.times do |i|
        ss = i * length
        t = (i + 1) * length
        movie.transcode("part_#{i}.mp4", %W(-ss #{format(ss)} -t #{format(t)} -async 1 -c copy))
      end
    end

    def format(seconds)
      Time.at(seconds).utc.strftime("%H:%M:%S")
    end
  end
end
