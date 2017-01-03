# Speedrail

Application template for starting new rails applications with the technologies I like.

Includes:

1. Rails 5
  - Bootstrap 3
2. Testing (with RSpec)
  - Capybara configured for feature tests
  - Factory Girl
  - Pry

## Usage

Prerequisites:
1. To automatically create git repositor, 2 environment variables need to be set: `GITHUB_USER` and `GITHUB_TOKEN`.
  - `GITHUB_TOKEN` can be generated at https://github.com/settings/tokens
  - export them like `export GITHUB_USER=myuser`
2. Postgres must be installed. E.g. `brew install postgres` on MacOS

```bash
rails new <app name> --template speedrail/template.rb
```

## Tips

To set global defaults for new rails projects, create `~/.railsrc` with suitable command line flags for you. Mine are:

```
--skip-test-unit
--skip-bundle
--database=postgresql
--skip-keeps
```

## Future developments

Currently this is just plain rails app with couple cleanup & added gems. Cleaner solution would be to package it as a gem and provide generators with configurations.

Features to add:
  - [ ] instead of hard copy, see how it could be implemented using rails generators
  - [ ] automatic CI integration
  - [ ] setting application name
