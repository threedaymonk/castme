xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0', 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd' do
  xml.channel do
    xml.title @feed.name
    xml.language 'en-uk'
    xml.itunes :image, href: "#{ request.url }icon.jpg"
    xml.itunes :author, 'Various'
    xml.itunes :category, 'Random'
    xml.copyright ''
    @feed.shows.each do |show|
      xml.item do
        xml.title show.name
        xml.enclosure url: "#{ request.base_url }/#{ show.url }", type: 'audio/mpeg'
        xml.guid show.guid
        xml.pubDate show.date.rfc2822
        xml.description show.description
      end
    end
  end
end
