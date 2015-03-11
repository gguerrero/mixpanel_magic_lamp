require 'mixpanel_magic_lamp/configuration'
require 'mixpanel_magic_lamp/engine' if defined? Rails
require 'mixpanel_magic_lamp/mixpanel/expression_builder'
require 'mixpanel_magic_lamp/mixpanel/interface'

# Include and extend the magic lamp
Mixpanel.extend MixpanelMagicLamp::ClassMethods
Mixpanel.include MixpanelMagicLamp::Mixpanel
