## Unreleased

## [0.3.0] - 2023-07-04

- Feature: Allow optionally specifying an output file for the CSV
- Change: Add ID of the workflow run to the output
- Feature: Support restricting workflow runs examined since a given date
- Feature: Fetch all the workflow runs, not just the first 100
- Breaking: Removed the `list-workflows` command and renamed the `duration-history` to just `duration`
- Breaking: The `duration` command now accepts the workflow file name (or ID) instead of the name

## [0.2.0] - 2023-06-01

- Breaking: Add commands to the CLI: `version`, `list-worklows`, `duration-history`

## [0.1.1] - 2023-06-01

- Actually make the gem executable

## [0.1.0] - 2023-06-01

- Initial gem bundling
