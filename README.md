# Mixpanel Magic Lamp

[![Gem Version](https://badge.fury.io/rb/mixpanel_magic_lamp.svg)](https://badge.fury.io/rb/mixpanel_magic_lamp)

Rub the magic lamp and your desired Mixpanel ORM will appear!

If you're using [Mixpanel](https://mixpanel.com/) for your web site analytics you probably thought
in make reports exporting your data through any **Mixpanel API** client. This gem is your answer 
for not overwarming your head with so many doc, and it will remind you to ```ActiveRecord```.

## Install
You can install this *gem* by

```
$ gem install mixpanel_magic_lamp
```

Or bundle it on your app by adding this line at your *Gemfile*

```ruby
gem 'mixpanel_magic_lamp'
```

## Configuration
To setup this gem you should add API keys and other config:
```ruby
MixpanelMagicLamp.configure do |config|
  # Set your API Key/Secret
  config.api_key     = "YOUR MIXPANEL API KEY"
  config.api_secret  = "YOUR MIXPANEL API SECRET"

  # Run query in parallel (recomended for better performance)
  config.parallel = true

  # Default interval on from/to dates when dates are not provided
  config.interval = 30
end
```

### Rails config generator
Copy base config file on your **Rails app** by
```bash
rails generate mixpanel_magic_lamp:config
```


## Build your query
The most interesting feature from this library is probably the query builder, that
let you to build an 'ActiveRecord' like query to run API queries, it will remind you to
the Mixpanel UI:

### where
Start any query with this keyword, and extend is as long as you need.
This method accept a hash as first parameter where each pair of key/value are traslated
to "key == value" (*equals_to*), a second parameter may change union word:

```ruby
Mixpanel.where(country: 'Spain', gender: 'Female').to_s
=> "(properties[\"country\"] == \"Spain\" and properties[\"gender\"] == \"Female\")"

Mixpanel.where({country: 'Spain', gender: 'Female'}, 'or').to_s
=> "(properties[\"country\"] == \"Spain\" or properties[\"gender\"] == \"Female\")"
```


Then you may append any existent query build to complete your API query:

```ruby
Mixpanel.where(country: 'Spain').or.is_set('source').to_s
=> "(properties[\"country\"] == \"Spain\") or (defined (properties[\"source\"]))"
```

### and/or
Concat as many query builders as you need with ```and``` and ```or``` operators:

```ruby
Mixpanel.where(country: "Spain", browser: "Chrome")
        .and.is_set('device_type')
        .and.does_not_equal(user_type: 'bot')
        .and.contains(url: '/sales')
=> "(properties[\"country\"] == \"Spain\" and properties[\"browser\"] == \"Chrome\") and (defined (properties[\"device_type\"])) and (properties[\"user_type\"] != \"bot\") and (\"/sales\" in (properties[\"url\"]))">
```


### on
Use it as **by** statement on your UI, in order to group segmentation:

```ruby
Mixpanel.on('country')
=> "properties[\"country\"]"
```

### Builders

#### equals

```ruby
Mixpanel.where.and.equals(country: 'Spain', user_type: 'human').to_s
=> "(properties[\"country\"] == \"Spain\" and properties[\"user_type\"] == \"human\")"
```

#### does_not_equal

```ruby
Mixpanel.where.and.does_not_equal(country: 'Spain', user_type: 'human')
=> "(properties[\"country\"] != \"Spain\" and properties[\"user_type\"] != \"human\")"
```

#### contains

```ruby
Mixpanel.where.and.contains(country: 'Spain', user_type: 'human').to_s
=> "(\"Spain\" in (properties[\"country\"]) and \"human\" in (properties[\"user_type\"]))"
```

#### does_not_contain

```ruby
Mixpanel.where.and.does_not_contain(country: 'Spain', user_type: 'human').to_s
=> "(not \"Spain\" in (properties[\"country\"]) and not \"human\" in (properties[\"user_type\"]))"
```

#### is_set

```ruby
Mixpanel.where.and.is_set(['country', 'user_type']).to_s
=> "(defined (properties[\"country\"]) and defined (properties[\"user_type\"]))"
```

#### is_not_set

```ruby
Mixpanel.where.and.is_not_set(['country', 'user_type']).to_s
=> "(not defined (properties[\"country\"]) and not defined (properties[\"user_type\"]))"
```


## Actions
Mixpanel API client has a lot of possible actions, so far these are the supported actions:

### Segmentation
Classic **Mixpanel** segmentation action, where you can specify *event name*, *from/to dates* and *any conditions* you want. Prepare and run as many request in parallel you need

```ruby
interface = Mixpanel::Interface.new

page_visits_query = Mixpanel.where("product" => 'Finances')
                            .and.is_set("subproduct")
page_visits  = interface.segmentation('Page visit', { from: Data.parse('2015-01-31'),
                                                      to: Date.today },
                                                    { where: page_visits_query })


login_clicks_query = Mixpanel.where("device_type" => 'mobile')
login_clicks = interface.segmentation('Login', { from: Data.parse('2015-04-01'),
                                                 to: Date.today },
                                               { where: login_clicks_query })

# Run all the queued queries
interface.run!

# Present your data...
p page_visits[:data]
p login_clicks[:data]
```
 
### Segmentation by
Same as **segmentation** but grouping the output by any property you want to.

```ruby
interface = Mixpanel::Interface.new

page_visits_query = Mixpanel.where("product" => 'Finances')
                            .and.is_set("subproduct")
page_visits  = interface.segmentation('Page visit', { from: Data.parse('2015-01-31'),
                                                      to: Date.today },
                                                    { where: page_visits_query,
                                                      on: Mixpanel.on('device_type') })

# Run all the queued queries
interface.run!

# Present your data...
p page_visits[:data]
```


## Your own interface
Now you master all the above concepts, the best thing you can do is to build your own interface model for extracting your reports:

```ruby
module Mixpanel
  class LandingPagesInterface < Mixpanel::Interface

    def initialize
      super()
    end

    def views(from: nil, to: nil)
      where_context = Mixpanel.where('page_type' => 'landing')
                              .and.is_set('device_type')

      segmentation 'Page view', { from: from, to: to },
                                { where: where_context }
    end

    def views_by_devices(from: nil, to: nil)
      where_context = Mixpanel.where('page_type' => 'landing')
                              .and.is_set('device_type')

      segmentation_interval 'Page view', { from: from, to: to },
                                         { where: where_context,
                                           on: Mixpanel.on('device_type') }
    end

  end
end

# Initialize your interface
landing_interface = Mixpanel::LandingPagesInterface.new

# Prepare all the queries
landing_last_week_views = landing_interface.views(from: 14.days.ago, to: 7.days.ago)
landing_this_week_views = landing_interface.views(from: 6.days.ago, to: Date.today)
landing_last_week_view_by_devices = landing_interface.views_by_devices(from: 14.days.ago, to: 7.days.ago)

# Run all the queries
landing_interface.run!

# Retrieve your data!
p landing_last_week_views[:data]
p landing_this_week_views[:data]
p landing_last_week_view_by_devices[:data]

```


## On top of mixpanel_client Gem
This ORM is build on top [mixpanel_client](https://github.com/keolo/mixpanel_client#mixpanel-data-api-client) gem.

You'll find the oficial mixpanel info [here](https://mixpanel.com/docs/api-documentation/data-export-api#libs-ruby).

### Monkey patching
On this gem you'll find a ```Mixpanel::Client``` class monkey patch to avoid exceptions raise
when any of the parallel request fails, i.e all the requests will run until completion and return
their correspondent HTTP status (error or success) and body as usual.
See it [here](https://github.com/gguerrero/mixpanel_magic_lamp/blob/master/lib/mixpanel_magic_lamp/client.rb).



## Contribution
If you have cool idea for improving this Gem or any bug fix just open a pull request and
I'll be glad to have a look and merge it if seems fine.


## License

This project rocks and uses [MIT-LICENSE](https://github.com/gguerrero/mixpanel_magic_lamp/blob/master/MIT-LICENSE).
