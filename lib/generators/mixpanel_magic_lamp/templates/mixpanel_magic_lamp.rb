MixpanelMagicLamp.configure do |config|
  # Set your API Key/Secret
  # config.api_key     = "YOUR MIXPANEL API KEY"
  # config.api_secret  = "YOUR MIXPANEL API SECRET"

  config.parallel = true
  config.interval = 30
end
