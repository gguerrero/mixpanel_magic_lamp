module MixpanelMagicLamp
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key,
                  :api_secret,
                  :parallel,
                  :interval

    def initialize
      @parallel = true
      @interval = 30
    end

  end

  class ApiKeyMissingError < StandardError
    def initialize
      super "Missing API key and/or secret. Please, configure them."
    end
  end
  
end
