module MixpanelMagicLamp

  class Formatter

    DEFAULT = 'values'

    def initialize(request)
      @response = request.response.handled_response.dup
    end

    def convert(format: DEFAULT)
      send :"to_#{format}"  
    end

    def to_values
      @response['data']['values']
    end

    def to_line
      @response['data']
    end

    def to_pie
      @response['data']['series'] = [ @response['data']['series'].first,
                                      @response['data']['series'].last ]
      date_for_value = @response['data']['series'].first

      @response['data']['values'].each do |section, values|
        @response['data']['values'][section] = @response['data']['values'][section][date_for_value]
      end

      @response['data']
    end

    def method_missing(method, *args)
      puts "Format '#{method}' not available. Formatting as 'to_#{DEFAULT}' instead."
      send :"to_#{DEFAULT}"
    end

  end

end
