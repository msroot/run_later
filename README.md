# RunLater

RunLater is a gem for running commands later. 
It saves the commands in a yaml file (`~/.run_later/commands.yaml`) and executed it when you call `perform`

Because when you running scripts with Ruby, systems commands are running with `sh` and doent `source` load any file like `~/.profile` or `.~/.bash_profile` so we need to `preload` it with before

## Usage

	$ run_later --preload="~/.profile" --commands="brew upgrade && brew install phantomjs"

later:

	$  run_later perform

`--preload`: scripts to preload
`--commands`:commands to run

`-c` alias for `--commands`
`-p` alias for `--preload`
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'run_later'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install run_later

@
## Contributing

1. Fork it ( https://github.com/msroot/run_later/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License

Copyright (c) 2015 Ioannis Kolovos

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
