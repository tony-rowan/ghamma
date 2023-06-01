# Ghamma
Fetch workflow run durations for Github Actions.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ghamma

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ghamma

## Usage

### Authentication

The Github workflows API requires an authenticated user, even for public repos.
To use this tool, you will need a 
[Github API Token](https://docs.github.com/en/rest/overview/authenticating-to-the-rest-api#authenticating-with-a-personal-access-token) 
with at least `read` access to the repo you want to look at.

Once you have that, make it available.

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
