require 'spec_helper'

describe Goszakup::Storage do
  let(:list) { [Goszakup::Purchase.new(1, 1, "ololo"), Goszakup::Purchase.new(2, 2, "trololo")] }

  let(:storage) { described_class.new }

  before { storage.purge! }

  describe "#save" do
    subject { storage.save list }

    it "should save" do
      expect(subject).to be_truthy
      expect(File.exist?("db/test.store")).to be_truthy
    end
  end

  describe "#fetch_new" do
    subject { storage.fetch_new list }

    let(:list) do
      [
        Goszakup::Purchase.new(1, 1, 'aoeu'),
        Goszakup::Purchase.new(2, 2, 'aoeu'),
        Goszakup::Purchase.new(3, 3, 'aoeu11')
      ]
    end

    context "when there are new items" do
      let(:old_list) do
        [
          Goszakup::Purchase.new(1, 1, 'aoeu'), Goszakup::Purchase.new(2, 2, 'aoeu')
        ]
      end

      before { storage.save old_list }

      it "should return new items" do
        expect(subject).to eq( [ Goszakup::Purchase.new(3, 3, 'aoeu11') ] )
      end
    end

    context "when storage is not initialized yet" do
      it "should return all list" do
        expect(subject).to eq(list)
      end
    end
  end

  describe "private #get" do
    subject { storage.send :get }

    before do
      storage.save list
    end

    it "should get" do
      expect(subject).to match_array([1, 2])
    end
  end
end
