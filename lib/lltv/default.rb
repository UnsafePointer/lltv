module LLTV
  class Default
    def self.store_path
      "#{Dir.home}/.lltv"
    end

    def self.sources_path
      "#{Dir.home}/.love_live/"
    end

    def self.file_name
      'love_live.gif'
    end

    def self.file_length
      5
    end

    def self.fps
      12
    end

    def self.workspace_path
      'workspace'
    end
  end
end
