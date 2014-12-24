CastMe
======

Podcasts are the best things in the world. Sometimes I get hold of radio shows, lectures, etc. which don't belong to their own RSS feed / podcast. I then promptly forget about them because it's a pain to load them into iTunes and give them the correct settings, etc.

This little Sinatra app will take a bunch of mp3 files and create an RSS feed for you to load them all into iTunes.

Usage
-----

1. Create a directory for each feed you wish to host under public.
2. Copy over the mp3 files you want to podcast into `public/<directory>`.
3. Host the app using your webserver of choice (or just type `rackup`)
4. Add the RSS url (`/<directory>.rss`) to your podcast listening program.
