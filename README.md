# Ghamma
Fetch workflow run durations for Github Actions.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ghamma

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ghamma

## Usage

Usage is currently very simple as the gem does very little. First, you need a token
with read access to the repo you are trying to collect metrics for and you need to make
it available to the gem.

```shell
$ export GH_TOKEN="YOUR_API_TOKEN"
```

Then, simply run, specifying the repo and a CSV of durations will be printed.

```shell
$ ghamma tony-rowan ghamma
Found 1 workflows
Fetched runs for Ruby
Fetched timings for Ruby
Ruby
Date,Duration
2023-06-01T15:31:33Z,19000
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test-unit` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tony-rowan/ghamma. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct](https://github.com/tony-rowan/ghamma/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ghamma project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/tony-rowan/ghamma/blob/main/CODE_OF_CONDUCT.md).
