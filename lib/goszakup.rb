require 'bundler'
Bundler.setup

require 'logger'

require 'goszakup/purchase'
require 'goszakup/list_fetcher'
require 'goszakup/storage'
require 'goszakup/word_analyzer'

require 'twitter'
require 'google_url_shortener'
require 'dotenv'
Dotenv.load

module Goszakup

  def self.logger
    @logger ||= Logger.new('logs/app.log')
  end

  def self.env
    ENV['APP_ENV'] ||= "production"
  end

  def self.production?
    env == "production"
  end

  def self.test?
    env == "test"
  end

  def self.invoke
    list = ListFetcher.new.fetch 0, 1000
    storage = Storage.new
    new_list = storage.fetch_new list
    analyzer = WordAnalyzer.new

    found_list = new_list.select &analyzer.method(:call)

    if found_list.any?
      if production?
        twitter_client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
          config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
          config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
          config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
        end

        Google::UrlShortener::Base.api_key = ENV["GOOGL_URL_SHORTENER_API_KEY"]

        found_list.each do |entry|
          long_url = "https://zakupki.gov.kg/popp/view/order/view.xhtml?id=#{entry.permalink_id}"
          url = Google::UrlShortener::Url.new(long_url: long_url)
          short_url = url.shorten!
          text = "#{short_url} #{entry.title}"[0...140]
          twitter_client.update(text)
        end
      else
        puts found_list.inspect
      end
    end

    storage.save list

    self.logger.info "Successfully invoked: #{list.count} #{new_list.count} #{found_list.count}"
  rescue
    self.logger.error $!.inspect
  end

  def self.fetch_all
    fetcher = ListFetcher.new
    offset = 0
    limit = 1000
    step = 0

    while list = fetcher.fetch(step * limit, limit) do
      if block_given?
        yield list
      end
      step += 1
    end
  end

end
