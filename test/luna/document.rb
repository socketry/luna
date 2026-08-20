# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require_relative "../../lib/luna/document"

describe Luna::Document do
	let(:document) {Luna::Document.new}
	
	it "renders a complete document" do
		html = document.call("readme.md", "<h1>Hello</h1>")
		expect(html).to be(:start_with?, "<!doctype html>")
		expect(html).to be(:include?, "<meta charset=\"utf-8\">")
		expect(html).to be(:include?, "<title>readme.md</title>")
		expect(html).to be(:include?, "<h1>Hello</h1>")
	end
	
	it "links the stylesheet" do
		html = document.call("readme.md", "")
		expect(html).to be(:include?, "<link rel=\"stylesheet\" href=\"/_static/luna.css\">")
	end
	
	it "escapes the title" do
		html = document.call("<script>", "")
		expect(html).to be(:include?, "<title>&lt;script&gt;</title>")
	end
	
	with "scripts" do
		let(:document) {Luna::Document.new(scripts: ["/_static/application.js"])}
		
		it "includes a module script" do
			html = document.call("readme.md", "")
			expect(html).to be(:include?, "<script type=\"module\" src=\"/_static/application.js\"></script>")
		end
	end
	
	with "no stylesheet" do
		let(:document) {Luna::Document.new(stylesheet: nil)}
		
		it "omits the link" do
			expect(document.call("readme.md", "")).not.to be(:include?, "<link")
		end
	end
end
