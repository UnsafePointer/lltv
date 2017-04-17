require 'yaml'
require 'lltv/default'
require 'twitter'

module LLTV
  class Bot
    attr_reader :authorization

    def initialize()
      @authorization = YAML.load_file(Default.authorization_file_path)
    end

    def post
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = authorization['consumer_key']
        config.consumer_secret = authorization['consumer_secret']
        config.access_token = authorization['access_token']
        config.access_token_secret = authorization['access_token_secret']
      end
      client.update_with_media(Default.hashtags.join(' '), File.new(Default.file_name))
    end
  end
end
