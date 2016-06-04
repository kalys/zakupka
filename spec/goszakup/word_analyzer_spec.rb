require 'spec_helper'

describe Goszakup::WordAnalyzer do

  subject { described_class.new.(purchase) }

  context "when entry has latinic mixin" do
    let(:purchase) { Goszakup::Purchase.new(166, 166, "Бoкoчо кoкoчо") }

    it { is_expected.to be_truthy }
  end

  context "when entry has no latinic mixin" do
    let(:purchase) { Goszakup::Purchase.new(166, 1, "Бокочо кокочо") }
    it { is_expected.to be_falsy }
  end

  context "when there are latinic words" do
    let(:purchase) { Goszakup::Purchase.new(166, 1, "Bokocho кокочо") }
    it { is_expected.to be_falsy }
  end
end
