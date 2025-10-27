# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "protocol/http/middleware"

begin
	require "markly"
rescue LoadError
	# The gemspec declares dependency, but handle gracefully if not present at runtime.
end

module Luna
	module Middleware
		# Render Markdown files to HTML on-the-fly.
		# Intercepts requests that target .md/.markdown files.
		class Markdown < Protocol::HTTP::Middleware
			def initialize(app, root: Dir.pwd, index_candidates: ["index.md", "README.md"]) 
				super(app)
				@root = File.expand_path(root)
				@index_candidates = index_candidates
			end
			
			attr :root
			attr :index_candidates
			
			def safe_join(path)
				full = File.expand_path(File.join(@root, path))
				return nil unless full.start_with?(@root)
				full
			end
			
			def call(request)
				return super unless request.method == "GET" || request.method == "HEAD"
				path = request.path.split("?", 2).first
				
				fs_path = safe_join(path)
				return super unless fs_path
				
				if File.directory?(fs_path)
					candidate = @index_candidates.map {|n| File.join(fs_path, n)}.find {|p| File.file?(p)}
					return render_file(candidate, head: request.method == "HEAD") if candidate
				elsif File.file?(fs_path) && markdown_file?(fs_path)
					return render_file(fs_path, head: request.method == "HEAD")
				end
				
				super
			end
			
			private
			
			def markdown_file?(path)
				[".md", ".markdown"].include?(File.extname(path).downcase)
			end
			
			def render_html(markdown)
				if defined?(::Markly)
					::Markly.render_html(markdown)
				else
					# Fallback minimal rendering if markly isn't available:
					escape = ->(s){s.to_s.gsub("&","&amp;").gsub("<","&lt;").gsub(">","&gt;")}
					"<pre>" + escape.call(markdown) + "</pre>"
				end
			end
			
			def render_file(path, head: false)
				content = File.read(path)
				html = render_html(content)
				headers = [
						["content-type", "text/html; charset=utf-8"]
					]
				Protocol::HTTP::Response[200, headers, head ? nil : [html]]
			end
		end
	end
end
