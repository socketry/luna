# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "async/http/server"
require "protocol/http/middleware/builder"
require "protocol/http/content_encoding"

require_relative "middleware/verbose"
require_relative "middleware/static"
require_relative "middleware/markdown"

module Luna
	# HTTP server hosting a middleware stack for static content.
	class Server < Async::HTTP::Server
		# Build a middleware for serving static files with optional markdown and logging.
		# @param root [String] Root directory for content.
		# @param verbose [Boolean] Enable verbose logging.
		# @param markdown [Boolean] Enable markdown rendering.
		# @param index [String] Index file for directories.
		# @param directory_listing [Boolean] Enable basic directory listing when no index exists.
		def self.middleware(root: Dir.pwd, verbose: false, markdown: true, index: "index.html", directory_listing: true)
			::Protocol::HTTP::Middleware.build do
				use Luna::Middleware::Verbose if verbose
				use ::Protocol::HTTP::ContentEncoding
				use Luna::Middleware::Markdown, root: root if markdown
				run Luna::Middleware::Static.new(
					->(request){Protocol::HTTP::Response[404, {"content-type"=>"text/plain"}, ["Not Found"]]},
					root: root,
					index: index,
					directory_listing: directory_listing
				)
			end
		end
	end
end
