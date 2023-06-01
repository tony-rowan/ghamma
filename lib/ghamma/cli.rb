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

    class ListWorkflows < Dry::CLI::Command
      desc "List workflows on the given repo"

      argument :owner, required: true
      argument :repo, required: true

      def call(owner:, repo:)
        workflows = GithubApiClient.new(owner: owner, repo: repo, token: ENV["GH_TOKEN"]).fetch_workflows
        puts "Found #{workflows.size} workflows"
        workflows.each { |workflow| puts workflow[:name] }
        puts
      end
    end

    class DurationHistory < Dry::CLI::Command
      desc "List the duration of each successful workflow run"

      argument :owner, required: true
      argument :repo, required: true
      argument :workflow, required: true

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
    register "list-workflows", ListWorkflows
    register "duration-history", DurationHistory
  end
end
