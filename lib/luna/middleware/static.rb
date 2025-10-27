# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "protocol/http/middleware"
require "protocol/http/body/file"
require "time"

module Luna
	module Middleware
		# Serve static files from a root directory, with optional index and directory listing.
		class Static < Protocol::HTTP::Middleware
			MIME_TYPES = {
				".html" => "text/html; charset=utf-8",
				".css" => "text/css",
				".js" => "application/javascript",
				".json" => "application/json",
				".xml" => "application/xml",
				".txt" => "text/plain; charset=utf-8",
				".md" => "text/markdown; charset=utf-8",
				".png" => "image/png",
				".jpg" => "image/jpeg",
				".jpeg" => "image/jpeg",
				".gif" => "image/gif",
				".svg" => "image/svg+xml",
				".ico" => "image/x-icon",
				".pdf" => "application/pdf",
				".zip" => "application/zip",
			}.freeze
			
			def initialize(app, root: Dir.pwd, index: "index.html", directory_listing: true)
				super(app)
				@root = File.expand_path(root)
				@index = index
				@directory_listing = directory_listing
			end
			
			attr :root
			attr :index
			attr :directory_listing
			
			def mime_type_for_extension(ext)
				MIME_TYPES[ext.downcase] || "application/octet-stream"
			end
			
			def safe_join(path)
				full = File.expand_path(File.join(@root, path))
				return nil unless full.start_with?(@root)
				full
			end
			
			def call(request)
				return super unless request.method == "GET" || request.method == "HEAD"
				# Remove query and decode percent-encoding carefully:
				request_path = request.path.split("?", 2).first
				
				file_path = safe_join(request_path)
				return super unless file_path
				
				if File.exist?(file_path)
					if File.directory?(file_path)
						index_path = File.join(file_path, @index)
						if File.file?(index_path)
							return serve_file(index_path, head: request.method == "HEAD")
						elsif @directory_listing
							return serve_directory_listing(file_path, request_path)
						else
							return super
						end
					elsif File.file?(file_path)
						return serve_file(file_path, head: request.method == "HEAD")
					end
				end
				
				super
			end
			
			private
			
			def serve_file(path, head: false)
				stat = File.stat(path)
				headers = [
						["content-type", mime_type_for_extension(File.extname(path))],
						["last-modified", stat.mtime.httpdate],
					]
				
				body = head ? nil : Protocol::HTTP::Body::File.open(path)
				
				Protocol::HTTP::Response[200, headers, body]
			end
			
			def serve_directory_listing(dir_path, request_path)
				entries = Dir.entries(dir_path).sort - ["."]
				entries.reject! {|e| e == ".."} if request_path == "/"
				links = entries.map do |e|
					name = e
					target = File.join(request_path, e)
					target += "/" if File.directory?(File.join(dir_path, e)) && !target.end_with?("/")
					"<li><a href=\"#{escape_html(target)}\">#{escape_html(name)}</a></li>"
				end.join("\n")
				html = <<~HTML
				<!doctype html>
				<meta charset="utf-8">
				<title>Index of #{escape_html(request_path)}</title>
				<h1>Index of #{escape_html(request_path)}</h1>
				<ul>#{links}</ul>
			HTML
				
				headers = [
						["content-type", "text/html; charset=utf-8"]
					]
				
				Protocol::HTTP::Response[200, headers, [html]]
			end
			
			def escape_html(s)
				s.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
			end
		end
	end
end
