# HorizonEvent

Requests a years worth of sunrise/sunset times for cities in the US.
See [USNO](http://aa.usno.navy.mil/data/docs/RS_OneYear.php)

## Installation

Add this line to your application's Gemfile:

    gem 'horizon_event'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install horizon_event

## Usage

```ruby
  require "horizon_event"
  HorizonEvent::Delimited(delimiter: ",", city: "Birmingham", state: "AL").call
  #=> returns a CSV string representing sunrise/sunset times for a whole year

  HorizonEvent::KeyValuePairing.new(city: "Birmingham", state: "AL").call
  #=> returns a Hash of all the year's sunrise/sunset times

  HorizonEvent::Request.new(city: "Birmingham", state: "AL").call
  #=> returns the raw response from USNO (United States Naval Observatory)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/rthbound/horizon_event/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

