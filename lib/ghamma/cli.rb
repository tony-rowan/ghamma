require "dry/cli"

require_relative "./cli/version"
require_relative "./cli/duration"

module Ghamma
  module CLI
    extend Dry::CLI::Registry

    register "version", Version, aliases: ["v", "-v", "--version"]
    register "duration", Duration
  end
end
