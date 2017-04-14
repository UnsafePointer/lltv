require 'lltv/default'

module Magick
  class Image
    def specific_color_histogram(color)
      # 256 / 4
      buckets = Array.new(LLTV::Default.histogram_bucket_size, 0)
      step = 256 / 4
      color_histogram.each do |key, value|
        color_value = key.send(color.to_sym) / 256
        total_pixels = value
        Array(0..LLTV::Default.histogram_bucket_size).each_cons(2) do |min, max|
          if color_value > step * min and color_value < step * max
            buckets[min] += total_pixels
          end
        end
      end
      buckets.map { |bucket| bucket.to_f / (columns.to_f * rows.to_f) }
    end
  end
end
