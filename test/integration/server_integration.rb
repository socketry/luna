# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "sus/fixtures/async/http"
require "sus/fixtures/temporary_directory_context"
require "fileutils"

require_relative "../../lib/luna/server"

include Sus::Fixtures::Async::HTTP::ServerContext
include Sus::Fixtures::TemporaryDirectoryContext

let(:www_root) {File.join(root, "www")}

let(:app) do
	FileUtils.mkdir_p(www_root)
	Luna::Server.middleware(
		root: www_root,
		markdown: true,
		verbose: false,
		directory_listing: true
	)
end

it "serves index.html at root" do
	File.write(File.join(www_root, "index.html"), "<h1>Home</h1>")
	response = client.get("/")
	expect(response.status).to be == 200
	body = response.read
	expect(body).to be(:include?, "Home")
end

it "renders markdown files as html" do
	File.write(File.join(www_root, "README.md"), "# Hello\n\nThis is **Markdown**.")
	response = client.get("/README.md")
	expect(response.status).to be == 200
	expect(response.headers["content-type"]).to be(:start_with?, "text/html")
	html = response.read
	# We don't assert exact HTML as it depends on markly version; check for a known word:
	expect(html).to be(:include?, "Hello")
end

it "serves directory index when present" do
	FileUtils.mkdir_p(File.join(www_root, "docs"))
	File.write(File.join(www_root, "docs", "index.html"), "<p>Docs</p>")
	response = client.get("/docs/")
	expect(response.status).to be == 200
	expect(response.read).to be(:include?, "Docs")
end

it "lists directory when no index and listing enabled" do
	FileUtils.mkdir_p(File.join(www_root, "list"))
	File.write(File.join(www_root, "list", "file.txt"), "data")
	response = client.get("/list/")
	expect(response.status).to be == 200
	expect(response.headers["content-type"]).to be(:include?, "text/html")
	expect(response.read).to be(:include?, "file.txt")
end

it "handles HEAD requests without body" do
	File.write(File.join(www_root, "file.json"), '{"a":1}')
	response = client.head("/file.json")
	expect(response.status).to be == 200
end
