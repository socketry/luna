# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require_relative "command/serve"

module Luna
	module Command
		def self.call(*arguments)
			Serve.call(*arguments)
		end
	end
end
