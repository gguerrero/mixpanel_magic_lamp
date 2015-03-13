require 'mixpanel_client'

module MixpanelMagicLamp

  module InstanceMethods
    class Interface < ::Mixpanel::Client
      attr_reader :responses, :e, :status

      def initialize(interval: nil, parallel: nil, unit: 'day', type: 'unique')
        if MixpanelMagicLamp.configuration.api_key.nil? or 
           MixpanelMagicLamp.configuration.api_secret.nil?
          raise MixpanelMagicLamp::ApiKeyMissingError
        end

        @parallel = parallel.nil? ? MixpanelMagicLamp.configuration.parallel : parallel
        @interval = interval.nil? ? MixpanelMagicLamp.configuration.interval : interval 
        @from     = @interval.days.ago.to_date
        @to       = Date.today
        @unit     = unit
        @type     = type

        @responses = []
        @formatter = MixpanelMagicLamp::Formatter.new

        super api_key:    MixpanelMagicLamp.configuration.api_key,
              api_secret: MixpanelMagicLamp.configuration.api_secret,
              parallel:   @parallel
      end

      def segmentation(event, dates = {}, options = {})
        dates = { from: dates[:from] || @from, to: dates[:to] || @to }
        @r = request 'segmentation',
                     { event: event,
                       type: @type,
                       unit: @unit,
                       from_date: dates[:from].strftime('%Y-%m-%d'),
                       to_date: dates[:to].strftime('%Y-%m-%d') }.merge(options)
      end

      def segmentation_interval(event, dates = {}, options = {})
        dates = { from: dates[:from] || @from, to: dates[:to] || @to }

        @r = request 'segmentation',
                     { event: event,
                       type: @type,
                       interval: (dates[:to] - dates[:from]).to_i + 1,
                       from_date: dates[:from].strftime('%Y-%m-%d'),
                       to_date: dates[:to].strftime('%Y-%m-%d') }.merge(options)
      end

      def run
        run_parallel_requests if parallel
      rescue => e
        @e = { error: e.message, backtrace: e.backtrace }
      end

      def format(type: 'line')
        @status = @r.response.code
        return JSON.parse(@r.response.body) if @status < 200 or @status > 299

        response = @r.response.handled_response
        if type == 'line'
          response['data']
        elsif type == 'pie'
          response['data']['series'] = [ response['data']['series'].first,
                                         response['data']['series'].last ]
          date_for_value = response['data']['series'].first

          response['data']['values'].each do |section, values|
            response['data']['values'][section] = response['data']['values'][section][date_for_value]
          end
          response['data']
        else
          response['data']['values']
        end
      end

    end
  end

end
