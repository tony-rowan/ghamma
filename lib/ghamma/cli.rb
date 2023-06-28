require "csv"
require "dry/cli"
require "http"

require_relative "./github_api_client"
require_relative "./version"

module Ghamma
  module CLI
    extend Dry::CLI::Registry

    class Version < Dry::CLI::Command
      desc "Print version"

      def call(*)
        puts VERSION
      end
    end

    class Duration < Dry::CLI::Command
      desc "Track the duration of successful workflow runs over time"

      argument :owner, required: true, desc: "The user or organisation to whom the repo belongs"
      argument :repo, required: true, desc: "The repo to whom the workflow belongs"
      argument :workflow, required: true, desc: "The filename for the desired workflow, e.g. tests.yml"

      def call(owner:, repo:, workflow:)
        durations = GithubApiClient.new(owner: owner, repo: repo, token: ENV["GH_TOKEN"]).fetch_workflow_duration_history(workflow)

        durations_output = CSV.generate do |csv|
          csv << ["Date", "Duration"]
          durations.each do |duration|
            csv << duration
          end
        end

        puts durations_output
        puts
      end
    end

    register "version", Version, aliases: ["v", "-v", "--version"]
    register "duration", Duration
  end
end
