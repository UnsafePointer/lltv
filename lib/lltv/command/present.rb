require 'lltv/command'

module LLTV
  class Present < Command
    self.arguments = [
    ]

    def self.options
      [
      ].concat(super)
    end

    self.summary = <<-DESC
      
    DESC

    def initialize(argv)
      super
    end

    def validate!
      super
    end

    def run
      
    end
  end
end