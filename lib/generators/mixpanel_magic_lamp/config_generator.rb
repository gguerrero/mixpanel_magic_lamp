module MixpanelMagicLamp
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Generates the config initializer file for Mixpanel Magic Lamp options"
    def copy_initializer_file
      copy_file "mixpanel_magic_lamp.rb", "config/initializers/mixpanel_magic_lamp.rb"
    end
  end
end
