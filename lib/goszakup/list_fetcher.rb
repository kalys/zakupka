require 'mechanize'

module Goszakup
  class ListFetcher

    def fetch offset, limit
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
        "j_idt95:table_first" => offset,
        "j_idt95:table_rows" => limit,
        "j_idt95:table_encodeFeature" => "true",
        "j_idt95" => "j_idt95",
        "j_idt95:table_selection" => "",
        "javax.faces.ViewState" => view_state,
      }

      page = agent.post url, post_params, headers

      rows_str = page.search("//update[@id='j_idt95:table']").first.content

      doc = Nokogiri::HTML(rows_str)

      doc.css("tr").map do |tr|
        purchase_id = tr.css("td[1]").text.strip.to_i
        permalink_id = tr.attr("data-rk").to_i
        title = tr.css("td[4]").text.strip
        owner = tr.css("td[2]").text.strip
        price = tr.css("td[6]").text.strip
        begin
          datetime_string = tr.css("td[7]").text.strip
          if datetime_string
            publish_datetime = DateTime.parse "#{datetime_string} +0600"
            publish_datetime = publish_datetime.new_offset(6.0/24)
          end
        rescue ArgumentError
        end

        begin
          datetime_string = tr.css("td[8]").text.strip
          if datetime_string
            due_datetime = DateTime.parse "#{datetime_string} +0600"
            due_datetime = due_datetime.new_offset(6.0/24)
          end
        rescue ArgumentError
        end

        Purchase.new purchase_id, permalink_id, title, owner, price,
          publish_datetime, due_datetime

      end.reverse
    end
  end
end
