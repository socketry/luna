# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "console"
require "async/http/statistics"

module Luna
	module Middleware
		# Simple HTTP logging middleware adapted from Falcon.
		class Verbose < Protocol::HTTP::Middleware
			def initialize(app, logger = Console)
				super(app)
				@logger = logger
			end
			
			def annotate(request)
				task = Async::Task.current
				address = request.remote_address
				@logger.info(request, "-> #{request.method} #{request.path}", headers: request.headers.to_h, address: address.inspect)
				task.annotate("#{request.method} #{request.path} from #{address.inspect}")
			end
			
			def call(request)
				annotate(request)
				statistics = Async::HTTP::Statistics.start
				response = super
				statistics.wrap(response) do |body, error|
					@logger.info(request, "<- #{request.method} #{request.path}", headers: response.headers.to_h, status: response.status, body: body.inspect, error: error)
				end
				response
			end
		end
	end
end
