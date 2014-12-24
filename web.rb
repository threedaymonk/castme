require 'bundler/setup'
require 'builder'
require 'cgi'
require 'mp3info'
require 'naturally'
require 'sinatra'
require 'digest/sha1'

get '/' do
  Dir.chdir(File.expand_path('../public', __FILE__)) do
    @feeds = Dir['*'].select { |f| File.directory?(f) }.map { |f| Feed.new(f) }
    builder :index, content_type: :html
  end
end

get '/:name.rss' do |name|
  Dir.chdir(File.expand_path('../public', __FILE__)) do
    @feed = Feed.new(name)
    builder :rss
  end
end

Show = Struct.new(:url, :name, :date, :description) do
  def guid
    Digest::SHA1.hexdigest(url)
  end
end

class Feed
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
      show.url = file
      show.date = File.mtime(file)

      Mp3Info.open(file) do |mp3|
        show.name = mp3.tag.title || File.basename(file, '.mp3')
        show.description = [mp3.tag.artist, mp3.tag.comments].join("\r\n")
      end
    }
  end
end
