# Mixpanel Magic Lamp

[![Gem Version](https://badge.fury.io/rb/mixpanel_magic_lamp.svg)](http://badge.fury.io/rb/mixpanel_magic_lamp)

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


### Rails config generator
Copy base config file on your **Rails app** by
```bash
rails generator mixpanel_magic_lamp:config
```

## Actions
### Segementation
### Segmentation by

## Build your query
### where
### on
### Builders
* ```equals```
* ```does_not_equal```
* ```contains```
* ```does_not_contain```
* ```is_set```
* ```is_not_set```


## Your own interface


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
