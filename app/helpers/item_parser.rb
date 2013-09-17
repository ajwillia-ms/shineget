# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class ItemParser
  def self.parse(url)

    @item = Item.create
    @item.url = url

    if url[0..3] == 'file'
      url = url[7..-1]
    end

    doc = Nokogiri::HTML(open(url))

    @item.title = title_of_item doc
    @item.imgurl = image_of_item doc
    @item.price = price_of_item doc

    return @item
  end

  private
    def self.title_of_item(doc)
      if doc.at_css('h1')
        return doc.at_css('h1').text
      end
      return doc.title
    end

    def self.image_of_item(doc)
      return doc.xpath('//img').select{|image| image.attribute("src").to_s.scan(/icon|CSS/).empty?}[0]['src']
    end

    def self.price_of_item(doc)
      price_text = doc.at('p:contains("£")')

      if price_text
        return price_text.text.match(/(\d+[,.]\d+)/)
      end
      return 0.0
    end
end