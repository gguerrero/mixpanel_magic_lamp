module MixpanelMagicLamp
  
  module InstanceMethods

    def prepare_parallel_request
      request = ::Typhoeus::Request.new(@uri)

      request.on_complete do |response|
        Utils.to_hash(response.body, @format) if response.success? 
      end
    end

  end

end
