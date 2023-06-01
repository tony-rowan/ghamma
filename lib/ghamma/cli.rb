require "csv"
require "http"

module Ghamma
  class Cli
    BASE_URL = "https://api.github.com".freeze
    OWNER = ARGV[0].freeze
    REPOSITORY = ARGV[1].freeze

    def api_url(resource)
      "#{BASE_URL}#{resource}"
    end

    def get(resource, params = {})
      response = HTTP
        .auth("Bearer #{ENV["GH_TOKEN"]}")
        .get(api_url(resource), params: params)
        .body
      JSON.parse(response)
    end

    def fetch_workflows
      response = get "/repos/#{OWNER}/#{REPOSITORY}/actions/workflows"
      response["workflows"].map { |json| {id: json["id"], name: json["name"]} }.tap do |workflows|
        puts "Found #{workflows.size} workflows"
      end
    end

    def fetch_workflows_with_runs
      fetch_workflows.map do |workflow|
        response = get "/repos/#{OWNER}/#{REPOSITORY}/actions/workflows/#{workflow[:id]}/runs",
          {per_page: 100, status: "success", exclude_pull_requests: true, created: ">2023-05-01"}
        puts "Fetched runs for #{workflow[:name]}"

        next if response["total_count"].zero?

        {
          id: workflow[:id],
          name: workflow[:name],
          runs: response["workflow_runs"].map { |json| {id: json["id"], date: json["created_at"]} }
        }
      end.compact
    end

    def fetch_workflow_duration_metrics
      fetch_workflows_with_runs.map do |workflow|
        runs_with_timing = workflow[:runs].map do |workflow_run|
          response = get "/repos/#{OWNER}/#{REPOSITORY}/actions/runs/#{workflow_run[:id]}/timing"

          {
            duration: response["run_duration_ms"],
            date: workflow_run[:date]
          }
        end

        puts "Fetched timings for #{workflow[:name]}"

        {
          name: workflow[:name],
          runs: runs_with_timing
        }
      end
    end

    def print_workflow_duration_metrics
      fetch_workflow_duration_metrics.each do |workflow_metrics|
        puts workflow_metrics[:name]
        metrics_table = CSV.generate do |csv|
          csv << ["Date", "Duration"]
          workflow_metrics[:runs].each do |metric_datum|
            csv << [metric_datum[:date], metric_datum[:duration]]
          end
        end
        puts metrics_table
        puts
      end
    end
  end
end
