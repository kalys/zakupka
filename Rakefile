lib_dir = File.expand_path("../lib", __FILE__)

$:.unshift(lib_dir)

require 'goszakup'
require 'sequel'

namespace :goszakup do
  desc "Invoke"
  task :invoke do
    Goszakup.invoke
  end

  desc "Prepare DB for saving all records"
  task :prepare_db do
    db = Sequel.connect('sqlite://data.sqlite3')

    db.create_table :purchases do
      primary_key :id
      Integer :purchase_id
      Integer :permalink_id, unique: true
      String :title
      String :owner
      Float :price
      DateTime :publish_datetime
      DateTime :due_datetime
    end
  end

  desc "Save all data"
  task :save_all do
    db = Sequel.connect('sqlite://data.sqlite3')
    purchases = db[:purchases]

    Goszakup.fetch_all do |list|
      puts "Fetched #{list.count} records"
      list.each do |purchase|
        begin
          purchases.insert purchase.to_h
        rescue Sequel::UniqueConstraintViolation
        end
      end
      sleep 5
    end
  end

  desc "Export to CSV"
  task :export_to_csv do
    require 'csv'
    require 'pry-byebug'

    db = Sequel.connect('sqlite://data.sqlite3')
    purchases = db[:purchases]
    analyzer = Goszakup::WordAnalyzer.new

    CSV.open("purchases.csv", "wb") do |csv|
      purchases.each do |p|
        purchase = Goszakup::Purchase.new *p.values[1..-1]
        if analyzer.call(purchase)
          csv << p.values
        end
      end
    end
  end
end
