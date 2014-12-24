require 'bundler/setup'
require 'builder'
require 'cgi'
require 'mp3info'
require 'naturally'
require 'sinatra'

get '/' do
  Dir.chdir(File.expand_path('../public', __FILE__)) do
    @feed = Feed.new('shows')
    builder :rss
  end
end

class Feed
  Show = Struct.new(:url, :name, :date, :description)

  def initialize(path)
    @root = path
  end

  def name
    File.basename(@root)
  end

  def shows
    audio_files.
      sort_by { |f| Naturally.normalize(f) }.reverse.
      map { |f| show(f) }
  end

private

  def audio_files
    Dir[File.join(@root, '*.mp3')].select { |f| File.file?(f) }
  end

  def show(file)
    Show.new.tap { |show|
      show.url = escape_parts(file)
      show.date = File.mtime(file)

      Mp3Info.open(file) do |mp3|
        show.name = mp3.tag.title || File.basename(file, '.mp3')
        show.description = [mp3.tag.artist, mp3.tag.comments].join("\r\n")
      end
    }
  end

  def escape_parts(str)
    str.split('/').map { |s| CGI.escape(s) }.join('/')
  end
end
