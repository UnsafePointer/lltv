require 'claide'
require 'lltv/version'

module LLTV
  class Command < CLAide::Command
    require 'lltv/command/frames'
    require 'lltv/command/generate'
    require 'lltv/command/upload'
    require 'lltv/command/split'

    self.abstract_command = true
    self.command = 'lltv'
    self.version = LLTV::VERSION
    self.description = <<-DESC
      Love Live! TV, a Twitter bot inspired in @keion_tv
    DESC
  end
end
