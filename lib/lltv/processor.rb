require 'streamio-ffmpeg'
require 'rmagick'

module LLTV
  class Processor
    attr_reader :sources_path
    def initialize(sources_path)
      @sources_path = sources_path
    end

    def process(seektime, part)
      movie = FFMPEG::Movie.new(sources_path + "part_#{part}.m4v")
      frames_per_second = 12.to_f
      total_lenght_in_seconds = 5
      step = 1.to_f / frames_per_second
      total_steps = frames_per_second * total_lenght_in_seconds
      iter = seektime.to_f
      image_list = Magick::ImageList.new
      (0..total_steps).each do |step_number|
        path = "screenshots/#{'screenshot_%.2d.jpeg' % step_number}"
        movie.screenshot(path, seek_time: iter, quality: 1)
        iter += step.to_f
        image_list << Magick::Image.read(File.new(path)).first
      end
      image_list.write('love_live.gif')
    end
  end
end