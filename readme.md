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

## Releases

There are no documented releases.

## Contributing

We welcome contributions to this project.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature.'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create a new pull request.

### Running Tests

To run the test suite:

``` bash
$ bundle exec sus
```

### Making Releases

To make a new release:

``` bash
$ bundle exec bake gem:release:patch # or minor or major
```

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
