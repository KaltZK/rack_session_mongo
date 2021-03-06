# RackSessionMongo

Rack session store for MongoDB.

Fixed the problem "uninitialized constant Mongo::DB" in rack-session-mongo.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack_session_mongo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack_session_mongo

## Usage

```
require 'mongo'
require 'rake_session_mongo'
$db=Mongo::Client.new   ["localhost:27017"], :database=>'test'
configure do
    use Rack::Session::Mongo,:collection=>$db[:session]
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rack_session_mongo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

