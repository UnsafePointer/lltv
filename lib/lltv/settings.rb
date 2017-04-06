module LLTV
  class Settings
    def self.setup_ffmpeg_logger()
      filepath = Default.ffmpeg_log_path
      FileUtils.touch(filepath) unless File.exist? filepath
      logger = Logger.new(File.new(filepath, 'w'))
      FFMPEG.logger=(logger)
    end
  end
end
