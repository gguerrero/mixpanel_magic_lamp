require 'mixpanel_client'

module MixpanelMagicLamp

  module InstanceMethods
    class Interface < ::Mixpanel::Client

      attr_reader :queue

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

        @queue = MixpanelMagicLamp::Queue.new

        super api_key:    MixpanelMagicLamp.configuration.api_key,
              api_secret: MixpanelMagicLamp.configuration.api_secret,
              parallel:   @parallel
      end

      def segmentation(event, dates = {}, options = {})
        dates = { from: dates[:from] || @from, to: dates[:to] || @to }
        @queue.push request('segmentation',
                            { event: event,
                              type: @type,
                              unit: @unit,
                              from_date: dates[:from].strftime('%Y-%m-%d'),
                              to_date: dates[:to].strftime('%Y-%m-%d') }.merge(options)),
                    format: 'line'
      end

      def segmentation_interval(event, dates = {}, options = {})
        dates = { from: dates[:from].to_date || @from, to: dates[:to].to_date || @to }

        @queue.push request('segmentation',
                            { event: event,
                              type: @type,
                              interval: (dates[:to] - dates[:from]).to_i + 1,
                              from_date: dates[:from].strftime('%Y-%m-%d'),
                              to_date: dates[:to].strftime('%Y-%m-%d') }.merge(options)),
                    format: 'pie'
      end

      def run!
        run_parallel_requests
        @queue.process!
      end

    end
  end

end
