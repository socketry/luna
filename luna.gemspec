# frozen_string_literal: true

require_relative "lib/luna/version"

Gem::Specification.new do |spec|
	spec.name = "luna"
	spec.version = Luna::VERSION
	
	spec.summary = "A tiny, asynchronous static file server with optional Markdown rendering."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ["release.cert"]
	spec.signing_key = File.expand_path("~/.gem/release.pem")
	
	spec.homepage = "https://github.com/socketry/luna"
	
	spec.metadata = {
		"source_code_uri" => "https://github.com/socketry/luna.git",
	}
	
	spec.files = Dir.glob(["{bin,examples,lib}/**/*", "*.md"], File::FNM_DOTMATCH, base: __dir__)
	
	spec.executables = ["luna"]
	
	spec.required_ruby_version = ">= 3.2"
	
	spec.add_dependency "async"
	spec.add_dependency "async-http", "~> 0.75"
	spec.add_dependency "bundler"
	spec.add_dependency "console", ">= 1.30"
	spec.add_dependency "markly", [">= 0.6", "< 2.0"]
	spec.add_dependency "protocol-http", "~> 0.31"
	spec.add_dependency "samovar", "~> 2.3"
end
