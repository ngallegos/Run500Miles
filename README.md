# Run 500 Miles

A fitness tracking app for logging runs and walks throughout the year, with the goal of reaching 500 miles. Tracks distance, time, and activity type per user, with leaderboards, statistics, and charts.

## Requirements

- Ruby 4.0.1
- Bundler

### Installing Ruby

The recommended way to install Ruby is via Homebrew:

```bash
brew install ruby
```

Then add it to your PATH (add this to your `~/.zshrc` or `~/.bashrc`):

```bash
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
```

## Getting Started

```bash
# Install dependencies
bundle install

# Set up the database (create, migrate, and seed)
bundle exec rake db:setup

# Start the server
bundle exec rails server
```

The app will be available at `http://localhost:3000`.

## Running Tests

```bash
# Migrate the test database (first time only)
RAILS_ENV=test bundle exec rake db:migrate

# Run the full test suite
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/models/user_spec.rb

# Run a directory of specs
bundle exec rspec spec/controllers/
```

## CI

GitHub Actions runs the test suite on every push and pull request to `master`. See `.github/workflows/ci.yml`.
