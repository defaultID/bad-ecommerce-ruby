# bad-e-commerce-Ruby

The app has resembled an e-commerce website and it is the intentionally vulnerable Ruby web application ('dummy' app) to be used for teaching developers about secure coding through examples. And this application has the following vulnerabilities:
- Cross-Site Scripting
- SQL Injection
- XML Entity Expansion
- Authentication Bypass
- Authorization Bypass (horizontal)
- Path Traversal
- Cross-Site Request Forgery
- Sensitive Information Disclosure

## Requirements

- `Ruby` 3.0.1
- `bundler`
- `libmysqlclient-dev`
- `shared-mime-info` for uploads type check
- `Node.js` and `yarn`
- `MySQL` >= 5.7 (can be on the other host)

You can use system ruby or install the required version using `rvm` or `rbenv`.

## Installation

- clone the git repo
- run `bundle install` (`bundle help install` for available options)
- run `yarn install` to install frontend dependencies
- create MySQL user with access to `vulnerableapp_%` databases (or other name if you need)
- confugure environment variables or `.env` file for database access (see `.env.example`)
- run `./bin/rails db:setup` to load schema and initial data to MySQL database
- run `./bin/rails credentials:edit` and save the file to generate required secrets
- run `./bin/rails webpacker:compile` to compile js and css assets and prepare images for production env
- run `./bin/rails server` or use your favorite rack application server (passenger etc) to run the app
- use Rails console (`./bin/rails c`) to set user passwords:

  ```ruby
  User.find_by(email: 'user@vulnerableapp.com').update!(password: 'newpassword')
  ```

## Used gems, assets and libraries

### Backend

- Default Rails dependencies
- `slim` for templates (MIT License)
- parts of `dry-rb` for input validation (MIT License)
- `simple_form` to simplify form templates (MIT License)
- `countries` to see actual country names (MIT License)
- `country_select` for user country input (MIT License)
- `rails-i18n` to provide basic locale data (MIT License)
- `pundit` to authorize actions (MIT License)
- `mimemagic` to ensure that uploaded pictures are images (MIT License)
- `faraday` to simplify http request code (MIT License)

### Frontend
- `bootstrap` (MIT License)
- `tom-select` for user country input (Apache License 2.0)
- example images taken from [Openclipart](https://openclipart.org/) (CC0/Public domain)
