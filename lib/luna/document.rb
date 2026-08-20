# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

module Luna
	# Wraps rendered content in a minimal HTML document.
	#
	# Both the Markdown renderer and the directory listing use this, so that they
	# agree on the document structure and share the same stylesheet.
	class Document
		# @parameter stylesheet [String | Nil] The stylesheet to link, if any.
		# @parameter scripts [Array(String)] Module scripts to include.
		def initialize(stylesheet: "/_static/luna.css", scripts: [])
			@stylesheet = stylesheet
			@scripts = scripts
		end
		
		# @attribute [String | Nil] The stylesheet to link, if any.
		attr :stylesheet
		
		# @attribute [Array(String)] Module scripts to include.
		attr :scripts
		
		# @parameter title [String] The title of the document.
		# @parameter body [String] The rendered content.
		# @returns [String] A complete HTML document.
		def call(title, body)
			<<~HTML
				<!doctype html>
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1">
				<title>#{escape_html(title)}</title>
				#{head.join("\n")}
				#{body}
			HTML
		end
		
		private
		
		def head
			links = []
			
			if @stylesheet
				links << "<link rel=\"stylesheet\" href=\"#{escape_html(@stylesheet)}\">"
			end
			
			@scripts.each do |script|
				links << "<script type=\"module\" src=\"#{escape_html(script)}\"></script>"
			end
			
			links
		end
		
		def escape_html(text)
			text.to_s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub('"', "&quot;")
		end
	end
end
