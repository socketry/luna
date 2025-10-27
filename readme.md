# Luna

A tiny, asynchronous static file server with optional Markdown rendering, built on Protocol::HTTP and Async.

  - Static files via `Luna::Middleware::Static`
  - Optional Markdown-to-HTML via `Luna::Middleware::Markdown` (using `markly`)
  - Simple verbose logging via `Luna::Middleware::Verbose`

[![Development Status](https://github.com/socketry/luna/workflows/Test/badge.svg)](https://github.com/socketry/luna/actions?workflow=Test)

## Installation

Add this line to your application's Gemfile:

    gem "luna"

And then execute:

    bundle install

Or install it yourself as:

    gem install luna

## Usage

Serve the current directory:

    luna --bind http://localhost:3000

Options:

  - `--root PATH` (default: current directory)
  - `--index FILENAME` (default: `index.html`)
  - `--[no]-directory-listing` (default: `true`)
  - `--[no]-markdown` (default: `true`)
  - `--[no]-verbose`
  - `--bind URL` (default: `http://localhost:3000`)

## Programmatic Usage

    require "async"
    require "async/http/endpoint"
    require "luna/server"
    
    endpoint = Async::HTTP::Endpoint.parse("http://localhost:3000")
    app = Luna::Server.middleware(root: "/path/to/root", markdown: true)
    
    Async do |task|
      server = Luna::Server.new(app, endpoint, protocol: endpoint.protocol)
      server.run
    end
