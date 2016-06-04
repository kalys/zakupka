require 'yaml/store'

module Goszakup
  class Storage

    def initialize
      @db = YAML::Store.new("db/#{Goszakup.env}.store")
    end

    def save list
      @db.transaction do
        @db['list'] = list.map(&:first)
      end
    end

    def fetch_new list
      old_list = get

      return list unless old_list

      list.select do |entry|
        not old_list.include? entry.first
      end
    end

    def purge!
      @db.transaction do
        @db['list'] = nil
      end
    end

    private

    def get
      @db.transaction do
        @db['list']
      end
    end
  end
end
