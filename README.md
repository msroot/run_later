# RunLater

RunLater is a gem for running commands later. 
It saves the commands in a script file located in `~/.run_later/commands.sh` and executed it when you call `:perform`


	$ run_later --commands="brew upgrade && brew install phantomjs"

later:

	$  run_later perform

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'run_later'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install run_later

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/msroot/run_later/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
