require 'slack-ruby-bot'
require 'dotenv'
require 'open-uri'
require 'tempfile'

Dotenv.load

def process(gif_path, outfilename=nil)
  outfilename ||= File.basename(gif_path)

  `mkdir -p tmp`
  `convert -coalesce #{gif_path} tmp/frames-%03d.png`

  framerate = `identify -format "%T\n" #{gif_path} | head -n 1`.strip
  frames = Dir.glob('tmp/frames-*.png')
  darkest = 120
  first = (frames.size * 2 / 3)
  last = frames.size - 1
  overlay_start = ((last - first) * 0.5) + first
  step = darkest / first

  width = `identify -format "%w" tmp/frames-000.png`.to_i
  wasted_width = width/3
  resized_wasted = `convert img/wasted.png -resize #{wasted_width}x tmp/wasted_sized.png`

  (first..last).each do |i|
    img = 'tmp/frames-%03d.png' % i
    `convert #{img} -fill '#990000' -colorize #{step*(i-first+1)}% #{img}`
    `composite -gravity center tmp/wasted_sized.png #{img} #{img}` if i >= overlay_start
  end

  `convert -delay #{framerate} tmp/frames-*.png output/#{outfilename}`
  `rm -rf tmp`
  "output/#{outfilename}"
end

module WastedBot
  class App < SlackRubyBot::App
  end

  class Waste < SlackRubyBot::Commands::Base
    command 'waste' do |client, data, match|
      gif_url = match['expression'].gsub(/<|>/,'')
      outfilename = File.basename(URI.parse(gif_url).path)
      tempfile = open(gif_url)
      result = process(tempfile.path, outfilename)
      imgur_session = Imgurapi::Session.new(client_id: ENV['IMGUR_CLIENT_ID'],
                                            client_secret: ENV['IMGUR_CLIENT_SECRET'],
                                            access_token: ENV['IMGUR_ACCESS_TOKEN'],
                                            refresh_token: ENV['IMGUR_REFRESH_TOKEN'])
      image = imgur_session.image.image_upload(result)
      client.message text: image.link, channel: data.channel
    end
  end
end

WastedBot::App.instance.run
