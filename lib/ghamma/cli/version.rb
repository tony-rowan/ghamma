require "dry/cli"

require_relative "../version"

module Ghamma
  module CLI
    class Version < Dry::CLI::Command
      desc "Print version"

      def call(*)
        puts VERSION
      end
    end
  end
end
