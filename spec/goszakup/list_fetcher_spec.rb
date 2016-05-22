require 'spec_helper'

describe ListFetcher do
  describe "#fetch" do
    subject { described_class.new.fetch offset: offset }
    let(:offset) { }

    before do
      stub_request(:get, "https://zakupki.gov.kg/popp/view/order/list.xhtml").
         to_return(status: 200, body: IO.read("spec/fixtures/weblist.html"), headers: {'Content-Type' => 'text/html'})

      stub_request(:post, "https://zakupki.gov.kg/popp/view/order/list.xhtml").
         with(body: "javax.faces.partial.ajax=true&javax.faces.source=j_idt95%3Atable&javax.faces.partial.execute=j_idt95%3Atable&javax.faces.partial.render=j_idt95%3Atable&javax.faces.behavior.event=page&javax.faces.partial.event=page&j_idt95%3Atable_pagination=true&j_idt95%3Atable_first=0&j_idt95%3Atable_rows=100&j_idt95%3Atable_encodeFeature=true&j_idt95=j_idt95&j_idt95%3Atable_selection=&javax.faces.ViewState=1663256364816459529%3A6020058435274904459",
              headers: {'Accept'=>'application/xml, text/xml, */*; q=0.01', 'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7', 'Accept-Encoding'=>'gzip,deflate,identity', 'Accept-Language'=>'en-us,en;q=0.5', 'Connection'=>'keep-alive', 'Content-Length'=>'437', 'Content-Type'=>'application/x-www-form-urlencoded; charset=UTF-8', 'Faces-Request'=>'partial/ajax', 'Host'=>'zakupki.gov.kg', 'Origin'=>'https://zakupki.gov.kg', 'Referer'=>'https://zakupki.gov.kg/popp/view/order/list.xhtml', 'User-Agent'=>'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36', 'X-Requested-With'=>'XMLHttpRequest'}).
         to_return(status: 200, body: IO.read("spec/fixtures/list.xml"), headers: {"Content-Type" => "application/xml"})

    end

    it "should return array of titles" do
      expect(subject).not_to be_empty
    end
  end
end
