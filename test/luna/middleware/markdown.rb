# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "fileutils"
require "protocol/http/request"
require "protocol/http/response"
require "sus/fixtures/temporary_directory_context"

require_relative "../../../lib/luna/middleware/markdown"

describe Luna::Middleware::Markdown do
	include Sus::Fixtures::TemporaryDirectoryContext
	
	let(:www_root) {File.join(root, "www")}
	let(:app) {->(request) {Protocol::HTTP::Response[404, { "content-type" => "text/plain" }, ["Not Found"]]}}
	let(:middleware) {Luna::Middleware::Markdown.new(app, root: www_root)}
	
	def request(method, path)
		Protocol::HTTP::Request[method, path, [], nil]
	end
	
	it "renders markdown file as html" do
		FileUtils.mkdir_p(www_root)
		File.write(File.join(www_root, "README.md"), "# Hello\n\nThis is **Markdown**.")
		response = middleware.call(request("GET", "/README.md"))
		expect(response.status).to be == 200
		expect(response.headers["content-type"]).to be =~ /text\/html/
	end
	
	it "renders index.md in directory" do
		FileUtils.mkdir_p(File.join(www_root, "docs"))
		File.write(File.join(www_root, "docs", "index.md"), "# Docs Index")
		response = middleware.call(request("GET", "/docs/"))
		expect(response.status).to be == 200
	end
end
