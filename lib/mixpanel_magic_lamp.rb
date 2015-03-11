require 'mixpanel_magic_lamp/engine' if defined? Rails
require 'mixpanel_magic_lamp/mixpanel/expression_builder'
require 'mixpanel_magic_lamp/mixpanel/interface'

# Include salt and spieces on the magic lamp
Mixpanel.include MixpanelMagicLamp::Mixpanel
