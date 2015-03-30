# MONKEY PATCH!
# -------------
#
# Avoid 'fail' that makes all request to stop running...
# Original 4.1.1 lib/mixpanel/client.rb source:
#
# def prepare_parallel_request
#   request = ::Typhoeus::Request.new(@uri)
#
#   request.on_complete do |response|
#     if response.success?
#       Utils.to_hash(response.body, @format)
#     elsif response.timed_out?
#       fail TimeoutError
#     elsif response.code == 0
#       # Could not get an http response, something's wrong
#       fail HTTPError, response.curl_error_message
#     else
#       # Received a non-successful http response
#       if response.body && response.body != ''
#         error_message = JSON.parse(response.body)['error']
#       else
#         error_message = response.code.to_s
#       end
#
#       fail HTTPError, error_message
#     end
#   end
#
#   request
# end
#
#
module Mixpanel

  class Client
    def prepare_parallel_request
      request = ::Typhoeus::Request.new(@uri)

      request.on_complete do |response|
        Utils.to_hash(response.body, @format) if response.success? 
      end

      request
    end
  end

end
