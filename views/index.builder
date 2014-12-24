xml.declare! :DOCTYPE, :html
xml.html lang: 'en' do
  xml.head do
    xml.meta charset: 'utf-8'
    xml.title 'CastMe'
  end
  xml.body do
    xml.h1 'CastMe'
    xml.ul do
      @feeds.each do |feed|
        xml.li do
          xml.a feed.name, href: "/#{feed.name}.rss"
        end
      end
    end
  end
end
