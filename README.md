# wasted.exe

This is a Slack bot that will turn any GIF you give it into
a version of the ["wasted" meme](http://knowyourmeme.com/memes/wasted),
a joke based on the game over screen from the Grand Theft Auto series.

It's ideally deployed when you come across a GIF of a dog who misses a
landing or a person who falls over.

![](http://i.imgur.com/Jgicp9c.gif)

To set it up, you'll need a few things:

* Access to the imgur API
* Access to a Slack team with an available "bot" integration
* A computer the bot can run as a process on persistently

## API keys

After cloning, you need to create a `.env` file in the root directory of the repo. It should look something like this:

```
SLACK_API_TOKEN=  
IMGUR_CLIENT_ID= 
IMGUR_CLIENT_SECRET= 
IMGUR_ACCESS_TOKEN= 
IMGUR_REFRESH_TOKEN= 
```

The Slack API token is obtained by creating a new "bot" under the Slack admin integrations menu. Mark down the name of the bot when you create it; you'll be using it later to evoke the bot in your Slack channels.

The imgur variables are slightly more complicated; you can obtain the first two values by accessing the developer section of the imgur website and creating a new application. For the last two tokens please consult the documentation of this imgur gem](https://github.com/dncrht/imgur) unless you have a preferred way to get the values yourself.

Plug all the values you've obtained into the `.env` script after the `=` and save it.

## Running the ruby script

You should have a fairly modern ruby and the Bundler gem installed. Once you have that, run `bundle install` to get all the necessary gems installed.

If that succeeds, all you need to do is run `bundle exec ruby app.rb` to start the bot. Do it via a background process or a utility like screen or tmux to leave it running. If you've got the right Slack API key, you should see a line on the terminal mentioning which Slack team you've connected to.

## Evoking the bot

Once the bot is connected to the server, you'll want to invite it to some channels so you can use it. Go into the channel you want to use it from and type `/invite @BOTNAME`, where BOTNAME is what you named the bot during the integration setup step above. You should see a notification that the bot has joined the channel.

At this point, you can use `@BOTNAME waste URL` or `BOTNAME waste URL` to trigger the bot, where URL is the direct URL to a .gif file accessible on the web. It can take up to a minute to process the GIF and generate the new one, depending on the server you're running the bot on and how many frames make up the GIF you give it.


