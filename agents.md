# Agent

## Context

This section provides links to documentation from installed packages. It is automatically generated and may be updated by running `bake agent:context:install`.

**Important:** Before performing any code, documentation, or analysis tasks, always read and apply the full content of any relevant documentation referenced in the following sections. These context files contain authoritative standards and best practices for documentation, code style, and project-specific workflows. **Do not proceed with any actions until you have read and incorporated the guidance from relevant context files.**

**Setup Instructions:** If the referenced files are not present or if dependencies have been updated, run `bake agent:context:install` to install the latest context files.

### agent-context

Install and manage context files from Ruby gems.

#### [Getting Started](.context/agent-context/getting-started.md)

This guide explains how to use `agent-context`, a tool for discovering and installing contextual information from Ruby gems to help AI agents.

### async

A concurrency framework for Ruby.

#### [Getting Started](.context/async/getting-started.md)

This guide shows how to add async to your project and run code asynchronously.

#### [Scheduler](.context/async/scheduler.md)

This guide gives an overview of how the scheduler is implemented.

#### [Tasks](.context/async/tasks.md)

This guide explains how asynchronous tasks work and how to use them.

#### [Best Practices](.context/async/best-practices.md)

This guide gives an overview of best practices for using Async.

#### [Debugging](.context/async/debugging.md)

This guide explains how to debug issues with programs that use Async.

#### [Thread safety](.context/async/thread-safety.md)

This guide explains thread safety in Ruby, focusing on fibers and threads, common pitfalls, and best practices to avoid problems like data corruption, race conditions, and deadlocks.

### async-http

A HTTP client and server library.

#### [Getting Started](.context/async-http/getting-started.md)

This guide explains how to get started with `Async::HTTP`.

#### [Testing](.context/async-http/testing.md)

This guide explains how to use `Async::HTTP` clients and servers in your tests.

### bake

A replacement for rake with a simpler syntax.

#### [Getting Started](.context/bake/getting-started.md)

This guide gives a general overview of `bake` and how to use it.

#### [Command Line Interface](.context/bake/command-line-interface.md)

The `bake` command is broken up into two main functions: `list` and `call`.

#### [Project Integration](.context/bake/project-integration.md)

This guide explains how to add `bake` to a Ruby project.

#### [Gem Integration](.context/bake/gem-integration.md)

This guide explains how to add `bake` to a Ruby gem and export standardised tasks for use by other gems and projects.

#### [Input and Output](.context/bake/input-and-output.md)

`bake` has built in tasks for reading input and writing output in different formats. While this can be useful for general processing, there are some limitations, notably that rich object representations like `json` and `yaml` often don't support stream processing.

### covered

A modern approach to code coverage.

#### [Getting Started](.context/covered/getting-started.md)

This guide explains how to get started with `covered` and integrate it with your test suite.

#### [Configuration](.context/covered/configuration.md)

This guide will help you to configure covered for your project's specific requirements.

### io-event

An event loop.

#### [Getting Started](.context/io-event/getting-started.md)

This guide explains how to use `io-event` for non-blocking IO.

### metrics

Application metrics and instrumentation.

#### [Getting Started](.context/metrics/getting-started.md)

This guide explains how to use `metrics` for capturing run-time metrics.

#### [Capture](.context/metrics/capture.md)

This guide explains how to use `metrics` for exporting metric definitions from your application.

#### [Testing](.context/metrics/testing.md)

This guide explains how to write assertions in your test suite to validate `metrics` are being emitted correctly.

### protocol-http

Provides abstractions to handle HTTP protocols.

#### [Getting Started](.context/protocol-http/getting-started.md)

This guide explains how to use `protocol-http` for building abstract HTTP interfaces.

#### [Message Body](.context/protocol-http/message-body.md)

This guide explains how to work with HTTP request and response message bodies using `Protocol::HTTP::Body` classes.

#### [Headers](.context/protocol-http/headers.md)

This guide explains how to work with HTTP headers using `protocol-http`.

#### [Middleware](.context/protocol-http/middleware.md)

This guide explains how to build and use HTTP middleware with `Protocol::HTTP::Middleware`.

#### [Streaming](.context/protocol-http/streaming.md)

This guide gives an overview of how to implement streaming requests and responses.

#### [Design Overview](.context/protocol-http/design-overview.md)

This guide explains the high level design of `protocol-http` in the context of wider design patterns that can be used to implement HTTP clients and servers.

### protocol-http1

A low level implementation of the HTTP/1 protocol.

#### [Getting Started](.context/protocol-http1/getting-started.md)

This guide explains how to get started with `protocol-http1`, a low-level implementation of the HTTP/1 protocol for building HTTP clients and servers.

### protocol-http2

A low level implementation of the HTTP/2 protocol.

#### [Getting Started](.context/protocol-http2/getting-started.md)

This guide explains how to use the `protocol-http2` gem to implement a basic HTTP/2 client.

### samovar

Samovar is a flexible option parser excellent support for sub-commands and help documentation.

#### [Getting Started](.context/samovar/getting-started.md)

This guide explains how to use `samovar` to build command-line tools and applications.

### sus

A fast and scalable test runner.

#### [Getting Started](.context/sus/getting-started.md)

This guide explains how to use the `sus` gem to write tests for your Ruby projects.

### sus-fixtures-async-http

Test fixtures for running in Async::HTTP.

#### [Getting Started](.context/sus-fixtures-async-http/getting-started.md)

This guide explains how to use the `sus-fixtures-async-http` gem to test HTTP clients and servers.

### traces

Application instrumentation and tracing.

#### [Getting Started](.context/traces/getting-started.md)

This guide explains how to use `traces` for tracing code execution.

#### [Context Propagation](.context/traces/context-propagation.md)

This guide explains how to propagate trace context between different execution contexts within your application using `Traces.current_context` and `Traces.with_context`.

#### [Testing](.context/traces/testing.md)

This guide explains how to test traces in your code.

#### [Capture](.context/traces/capture.md)

This guide explains how to use `traces` for exporting traces from your application. This can be used to document all possible traces.
