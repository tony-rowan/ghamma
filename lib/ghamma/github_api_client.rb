require "http"

module Ghamma
  class GithubApiClient
    BASE_URL = "https://api.github.com".freeze

    def initialize(owner:, repo:, token:)
      @repo_base_url = "#{BASE_URL}/repos/#{owner}/#{repo}"
      @authorization_header = "Bearer #{token}"
    end

    def fetch_workflows
      get("/workflows")
        .fetch("workflows")
        .map do |workflow_json|
          workflow_json.transform_keys(&:to_sym).slice(:id, :name)
        end
    end

    def fetch_workflow_duration_history(workflow_name)
      workflow_id = get("/workflows").fetch("workflows")
        .find { |workflow| workflow["name"] == workflow_name }
        &.fetch("id", nil)

      if workflow_id.nil?
        raise "Could not find workflow with name #{workflow_name}"
      end

      workflow_runs = get(
        "/workflows/#{workflow_id}}/runs",
        {per_page: 100, status: "success", exclude_pull_requests: true}
      ).fetch("workflow_runs")
      .map do |workflow_run|
        run_timing = get("/runs/#{workflow_run["id"]}/timing")

        [
          workflow_run["created_at"],
          run_timing["run_duration_ms"]
        ]
      end
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
