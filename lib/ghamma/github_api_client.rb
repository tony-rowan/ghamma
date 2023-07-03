require "http"

module Ghamma
  class GithubApiClient
    BASE_URL = "https://api.github.com".freeze

    def initialize(owner:, repo:, token:)
      @repo_base_url = "#{BASE_URL}/repos/#{owner}/#{repo}"
      @authorization_header = "Bearer #{token}"
    end

    def fetch_workflow_duration_history(workflow_id, since, progressbar)
      pages = 2 # enough to do the first loop
      page = 1
      timings = []

      while page <= pages
        since_param = ">#{since}" if since

        response = get(
          "/workflows/#{workflow_id}/runs",
          {page: page, per_page: 100, status: "success", exclude_pull_requests: true, created: since_param}.compact
        )

        total_count = response["total_count"]
        progressbar.update(total: total_count)
        pages = total_count / 100
        page += 1

        response.fetch("workflow_runs").each do |workflow_run|
          run_timing = get("/runs/#{workflow_run["id"]}/timing")

          timings << [
            workflow_run["id"],
            workflow_run["created_at"],
            run_timing["run_duration_ms"]
          ]

          progressbar.advance

          sleep 0.1 # Try to keep under the Github rate limit
        end

        sleep 1 # Try to keep under the Github rate limit
      end

      timings
    end

    private

    attr_reader :repo_base_url, :authorization_header

    def get(resource, params = {})
      HTTP
        .auth(authorization_header)
        .get("#{repo_base_url}/actions#{resource}", params: params)
        .parse
    end
  end
end
