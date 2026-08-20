# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require_relative "luna/version"

module Luna
	# The root directory for Luna's own assets, e.g. stylesheets and scripts.
	PUBLIC_ROOT = File.expand_path("../public", __dir__)
end
