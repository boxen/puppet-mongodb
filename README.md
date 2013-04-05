# MongoDB Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-mongodb.png)](https://travis-ci.org/boxen/puppet-mongodb)

## Usage

```puppet
include mongodb
```

## Required Puppet Modules

* boxen
* homebrew
* stdlib

## Environment

Once installed, you can access the following variables in your environment, projects, etc:

* BOXEN_MONGODB_PORT: the configured mongodb port
* BOXEN_MONGODB_URL: the URL for mongodb, including localhost & port

### Ruby

For the [ruby client](http://api.mongodb.org/ruby/current/):

```ruby
@client = Mongo::MongoClient.new('localhost', ENV['BOXEN_MONGODB_PORT'] || 27017)
```

For [mongomapper](http://mongomapper.com/)'s `config/mongo.yml`:

```yaml
development:
  uri: <%= ENV['BOXEN_MONGODB_URL'] || 'mongodb://localhost:27017/' %>
```
