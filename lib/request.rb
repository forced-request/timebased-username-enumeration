require 'net/http'
require 'uri'

# Handles the network stuff, including request timing
class Request
	def initialize(username, opts)
		@username = username
		@opts = opts
	end

	def execute()
	# Find username parameter and replace
	data = replace_username(@opts.query_data, @username)
	uri = @opts.uri

	 if @opts.method == "POST" 
	 	# Split data into hash
	 	tmp_uri = URI(@opts.uri + "/?" + data)
	 	data = Hash[URI::decode_www_form(tmp_uri.query)]

	 	uri = URI.parse(uri)
	 	start_time = Time.now
	 	response = Net::HTTP.post_form(uri, data)
	 	end_time = Time.now
	 else
	 	uri = @opts.uri + "/?" + data
	 	uri = URI(uri)
	 	start_time = Time.now
	 	response = Net::HTTP.get(uri)
	 	end_time = Time.now
	 end
	 { :response_obj => response, :response_time => get_elapsed_ms(start_time, end_time)}
	end

	def get_elapsed_ms(time1, time2)
		(time2 - time1) * 1000
	end

	def replace_username(data,  username)
		data = data.gsub("PARAM", username)
		return data
	end
end