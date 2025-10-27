# Getting Started

This guide explains how to use the `sus-fixtures-async-http` gem to test HTTP clients and servers.

## Installation

Add the gem to your project:

``` bash
$ bundle add sus-fixtures-async-http
```

## Usage

Here is a simple example showing how to test the default server:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:response) {client.get("/")}

it 'can perform a request' do
	expect(response.read).to be == "Hello World!"
end
```

### Custom Applications

You can create a custom application to test your own HTTP handlers:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:app) do
	Protocol::HTTP::Middleware.for do |request|
		case request.path
		when "/"
			Protocol::HTTP::Response[200, {}, ["Home Page"]]
		when "/api/status"
			Protocol::HTTP::Response[200, {"content-type" => "application/json"}, ['{"status":"ok"}']]
		else
			Protocol::HTTP::Response[404, {}, ["Not Found"]]
		end
	end
end

it 'serves the home page' do
	response = client.get("/")
	expect(response.status).to be == 200
	expect(response.read).to be == "Home Page"
end

it 'serves API endpoints' do
	response = client.get("/api/status")
	expect(response.status).to be == 200
	expect(response.headers["content-type"]).to be == "application/json"
	expect(response.read).to be == '{"status":"ok"}'
end

it 'returns 404 for unknown paths' do
	response = client.get("/unknown")
	expect(response.status).to be == 404
end
```

### Testing Different HTTP Methods

Test various HTTP methods and request bodies:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:app) do
	Protocol::HTTP::Middleware.for do |request|
		case [request.method, request.path]
		when ["GET", "/users"]
			Protocol::HTTP::Response[200, {}, ['[{"id":1,"name":"John"}]']]
		when ["POST", "/users"]
			body = request.body.read
			Protocol::HTTP::Response[201, {}, ["Created: #{body}"]]
		when ["PUT", "/users/1"]
			body = request.body.read
			Protocol::HTTP::Response[200, {}, ["Updated: #{body}"]]
		when ["DELETE", "/users/1"]
			Protocol::HTTP::Response[204, {}, [""]]
		else
			Protocol::HTTP::Response[404, {}, ["Not Found"]]
		end
	end
end

it 'handles GET requests' do
	response = client.get("/users")
	expect(response.status).to be == 200
end

it 'handles POST requests' do
	response = client.post("/users", {}, ['{"name":"Alice"}'])
	expect(response.status).to be == 201
	expect(response.read).to be(:include?, "Alice")
end

it 'handles PUT requests' do
	response = client.put("/users/1", {}, ['{"name":"Bob"}'])
	expect(response.status).to be == 200
end

it 'handles DELETE requests' do
	response = client.delete("/users/1")
	expect(response.status).to be == 204
end
```

## Configuration Options

### Custom URLs and Ports

Override the server URL and endpoint options:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:url) {"http://localhost:9999"}

let(:endpoint_options) do
	{reuse_port: true, protocol: protocol, timeout: 30}
end

it 'uses custom configuration' do
	expect(bound_url).to be(:include?, ":9999")
end
```

### Protocol Selection

Test with different HTTP protocol versions:

``` ruby
include Sus::Fixtures::Async::HTTP::ServerContext

let(:protocol) {Async::HTTP::Protocol::HTTP2}

it 'uses HTTP/2 protocol' do
	response = client.get("/")
	expect(response).to have_attributes(version: "HTTP/2.0")
end
```
