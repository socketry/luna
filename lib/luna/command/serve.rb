# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "samovar"
require "async"
require "async/http/endpoint"

require_relative "../server"

module Luna
	module Command
		class Serve < Samovar::Command
			self.description = "Serve static files from a directory."
			
			options do
				option "-b/--bind <address>", "Bind address (e.g. http://localhost:3000)", default: "http://localhost:3000"
				option "-p/--port <number>", "Override port", type: Integer
				option "-h/--hostname <hostname>", "Override hostname"
				option "-t/--timeout <seconds>", "I/O timeout", type: Float, default: nil
				
				option "-r/--root <path>", "Root directory", default: nil
				option "-i/--index <filename>", "Directory index", default: "index.html"
				option "--[no]-directory-listing", "Enable directory listing", default: true
				option "--[no]-markdown", "Enable Markdown rendering", default: true
				option "-v/--[no]-verbose", "Verbose logging", default: false
			end
			
			# Optional positional argument for root directory
			one :path, "Root directory to serve", default: nil
			
			def root_directory
				# Use positional argument if provided, otherwise --root option, otherwise current directory
				if @path
					@path
				elsif @options[:root]
					@options[:root]
				else
					Dir.pwd
				end
			end
			
			def endpoint_options
				@options.slice(:hostname, :port, :timeout)
			end
			
			def endpoint
				Async::HTTP::Endpoint.parse(@options[:bind], **endpoint_options)
			end
			
			def middleware
				Luna::Server.middleware(
					root: File.expand_path(root_directory),
					verbose: @options[:verbose],
					markdown: @options[:markdown],
					index: @options[:index],
					directory_listing: @options[:directory_listing]
				)
			end
			
			def call
				Console.logger.info(self) do |buffer|
					buffer.puts "Luna v#{Luna::VERSION} serving..."
					buffer.puts "- Root: #{File.expand_path(root_directory)}"
					buffer.puts "- Bind: #{endpoint}"
					buffer.puts "- Markdown: #{@options[:markdown]} | Index: #{@options[:index]} | Directory Listing: #{@options[:directory_listing]}"
				end
				
				Async do |task|
					server = Luna::Server.new(middleware, endpoint, protocol: endpoint.protocol)
					
					server.run
					
					task.children.each(&:wait)
				end
			end
		end
	end
end
