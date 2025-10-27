# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "sus/fixtures"
require "protocol/http/request"
require "protocol/http/response"

require_relative "../../lib/luna/server"

describe Luna::Server do
	it "builds middleware" do
		app = Luna::Server.middleware(root: Dir.pwd, markdown: true)
		expect(app).to be_a Protocol::HTTP::Middleware
	end
end
