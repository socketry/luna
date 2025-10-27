# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "fileutils"
require "protocol/http/request"
require "protocol/http/response"

require_relative "../../../lib/luna/middleware/static"

describe Luna::Middleware::Static do
	around do |&block|
		Dir.mktmpdir do |root|
			@root = root
			super(&block)
		end
	end
	
	let(:root) {File.join(@root, "www")}
	let(:app) {->(request) {Protocol::HTTP::Response[404, { "content-type" => "text/plain" }, ["Not Found"]]}}
	let(:middleware) {Luna::Middleware::Static.new(app, root: root, index: "index.html", directory_listing: true)}
	
	def request(method, path)
		Protocol::HTTP::Request[method, path, [], nil]
	end
	
	with "serving files" do
		it "serves index.html from root" do
			FileUtils.mkdir_p(root)
			File.write(File.join(root, "index.html"), "<h1>Hello</h1>")
			response = middleware.call(request("GET", "/"))
			expect(response.status).to be == 200
			expect(response.headers["content-type"]).to be == "text/html; charset=utf-8"
		end
		
		it "serves a specific file" do
			FileUtils.mkdir_p(root)
			File.write(File.join(root, "hello.txt"), "world")
			response = middleware.call(request("GET", "/hello.txt"))
			expect(response.status).to be == 200
			expect(response.headers["content-type"]).to be == "text/plain; charset=utf-8"
		end
	end
	
	with "directories" do
		it "serves index file in subdirectory" do
			FileUtils.mkdir_p(File.join(root, "blog"))
			File.write(File.join(root, "blog", "index.html"), "<h1>Blog</h1>")
			response = middleware.call(request("GET", "/blog/"))
			expect(response.status).to be == 200
		end
		
		it "lists directory when no index" do
			FileUtils.mkdir_p(File.join(root, "list"))
			File.write(File.join(root, "list", "file.txt"), "data")
			response = middleware.call(request("GET", "/list/"))
			expect(response.status).to be == 200
			expect(response.headers["content-type"]).to be =~ /text\/html/
		end
	end
	
	with "head requests" do
		it "omits body" do
			FileUtils.mkdir_p(root)
			File.write(File.join(root, "file.json"), '{"a":1}')
			response = middleware.call(request("HEAD", "/file.json"))
			expect(response.status).to be == 200
		end
	end
end
