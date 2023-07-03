require "csv"
require "dry/cli"
require "http"
require "tty/progressbar"

require_relative "../github_api_client"

module Ghamma
  module CLI
    class Duration < Dry::CLI::Command
      desc "Track the duration of successful workflow runs over time"

      argument :owner, required: true, desc: "The user or organisation to whom the repo belongs"
      argument :repo, required: true, desc: "The repo to whom the workflow belongs"
      argument :workflow, required: true, desc: "The filename for the desired workflow, e.g. tests.yml"
      option :since, desc: "Fetch workflow runs since this date"
      option :output, desc: "Optional file to which to output results, defaults to STDOUT"

      def call(owner:, repo:, workflow:, since: nil, output: nil)
        workflow_statement = "Fetching the durations of all workflow runs of #{workflow}"
        since_statment = "since #{since}" if since

        puts [workflow_statement, since_statment].join(" ")

        progressbar = TTY::ProgressBar.new("Fetching workflow runs [:bar] :current/:total ETA: :eta", total: nil)

        durations = GithubApiClient.new(owner: owner, repo: repo, token: ENV["GH_TOKEN"])
          .fetch_workflow_duration_history(workflow, since, progressbar)

        progressbar.finish

        puts "Generating output"

        durations_output = CSV.generate do |csv|
          csv << ["ID", "Date", "Duration"]
          durations.each do |duration|
            csv << duration
          end
        end

        if output
          File.write(output, durations_output)
        else
          puts
          puts durations_output
          puts
        end

        puts "Done"
      end
    end
  end
end
