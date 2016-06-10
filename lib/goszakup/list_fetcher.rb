require 'mechanize'

module Goszakup
  class ListFetcher

    def fetch
      url = "http://zakupki.gov.kg/popp/view/order/list.xhtml"

      agent = Mechanize.new

      page = agent.get url

      view_state = page.css("input[name='javax.faces.ViewState']").first['value']

      headers = {
        "X-Requested-With" => "XMLHttpRequest",
        "Faces-Request" => "partial/ajax",
        "Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8",
        "Accept" => "application/xml, text/xml, */*; q=0.01",
        "Referer" => "https://zakupki.gov.kg/popp/view/order/list.xhtml",
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
        "Connection" => "keep-alive",
        "Origin" => "https://zakupki.gov.kg",
      }

      post_params = {
        "javax.faces.partial.ajax" => "true",
        "javax.faces.source" => "j_idt95:table",
        "javax.faces.partial.execute" => "j_idt95:table",
        "javax.faces.partial.render" => "j_idt95:table",
        "javax.faces.behavior.event" => "page",
        "javax.faces.partial.event" => "page",
        "j_idt95:table_pagination" => "true",
        "j_idt95:table_first" => "0",
        "j_idt95:table_rows" => "1000",
        "j_idt95:table_encodeFeature" => "true",
        "j_idt95" => "j_idt95",
        "j_idt95:table_selection" => "",
        "javax.faces.ViewState" => view_state,
      }

      page = agent.post url, post_params, headers

      rows_str = page.search("//update[@id='j_idt95:table']").first.content

      doc = Nokogiri::HTML(rows_str)

      doc.css("tr").map do |tr|
        Purchase.new tr.css("td[1]").text.strip.to_i, tr.attr("data-rk").to_i, tr.css("td[4]").text.strip
      end.reverse
    end
  end
end
