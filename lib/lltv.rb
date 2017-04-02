require 'lltv/version'
require 'lltv/command'
require 'claide'

module LLTV
  def self.run
    Command.run(ARGV)
  end
end
