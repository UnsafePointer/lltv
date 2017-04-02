require 'claide'
require 'lltv/version'

module LLTV
  class Command < CLAide::Command
    require 'lltv/command/present'

    self.abstract_command = true
    self.command = 'lltv'
    self.version = LLTV::VERSION
    self.description = <<-DESC
      Love Live! TV, a Twitter bot inspired in @keion_tv
    DESC
  end
end
