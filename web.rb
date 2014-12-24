require 'bundler/setup'
require 'builder'
require 'cgi'
require 'mp3info'
require 'naturally'
require 'sinatra'

get '/' do
  @shows = get_shows
  builder :rss
end

Show = Struct.new(:url, :name, :date, :description)

def show(file)
  return nil unless File.file?(file)

  Show.new.tap { |show|
    show.url = "shows/#{CGI::escape(File.basename(file))}"
    show.date = File.mtime(file)

    Mp3Info.open(file) do |mp3|
      show.name = mp3.tag.title || File.basename(file, '.mp3')
      show.description = [mp3.tag.title,mp3.tag.artist,mp3.tag1.comments].join("\n\r")
    end
  }
end

def get_shows
  shows_dir = File.expand_path('../public/shows', __FILE__)
  Dir[File.join(shows_dir, '*.mp3')].
    sort_by { |f| Naturally.normalize(f) }.reverse.
    map { |f| show(f) }.compact
end
