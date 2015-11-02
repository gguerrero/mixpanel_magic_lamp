$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mixpanel_magic_lamp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mixpanel_magic_lamp"
  s.version     = MixpanelMagicLamp::VERSION
  s.authors     = ["Guillermo Guerrero"]
  s.email       = ["g.guerrero.bus@gmail.com"]
  s.homepage    = "https://github.com/gguerrero/mixpanel_magic_lamp#mixpanel-magic-lamp"
  s.summary     = "Mixpanel client ORM!"
  s.description = "Mixpanel client ORM for easy querying and reporting data."
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")
  s.add_dependency "mixpanel_client", ">= 4.1.1"
end
