module Goszakup
  class WordAnalyzer

    def call purchase
      purchase.title.split(/\W+/).any? do |word|
        /[acoeyACTOEPYHKXBM]+/ =~ word and /[а-яА-Я]+/ =~ word
      end
    end
  end
end
