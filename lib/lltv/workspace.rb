require 'lltv/default'

module LLTV
  class Workspace
    def self.change_directory
      Dir.mkdir(Default.workspace_path) unless File.exist?(Default.workspace_path)
      Dir.chdir(Default.workspace_path) do
        yield
      end
    end
  end
end
