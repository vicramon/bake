# Bake

### WARNING: This is a prototype and a work in progress.

Run your Rails test suite in parallel on multiple Heroku instances. The goal of this project is to cut the running time of >10 minute test suites to <1 minute.

## Requirements

* Heroku Toolbelt -- installed with brew. If you downloaded it from Heroku you may need to uninstall it and run `brew install heroku`. Heroku's version relies on Ruby 1.9.3, which can cause problems.

* Be logged in to Heroku through the toolbelt.

## Setup

Add `bake-heroku` to your Gemfile. Make sure it's under the test group.

```
group :test do
  gem 'bake-heroku'
end
```

Run bundle.

```
$ bundle
```

Setup bake with `bake init`. Pass the number of Heroku instances you want to create to the `-n` flag:

```
$ bake init -n 5
```

## Run

Run your cucumber tests with:

```
$ bake
```
