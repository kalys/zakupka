module Goszakup
  class WordAnalyzer

    def call purchase
      purchase.title.split(/[^[[:word:]]]+/).any? do |word|
        /[acoeyACTOEPYHKXBM]+/ =~ word and /[а-яА-Я]+/ =~ word
      end
    end
  end
end
