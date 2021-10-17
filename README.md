# ProSeeker

ProSeeker is a platform that connects professionals and users that need professionals to work on their projects.

## Getting Started

### Prerequisites

You must have both Ruby and Rails installed. For more information, check the section [Tools used during development](#Tools-used-during-development)

### Installing

Clone the project
Navigate to the root folder of the project and then run
```
bin/setup
```

### Running

*OPTIONAL:* If you wish to populate the database with a few examples, you can run the following commands,
which will then create several records which will allow you to navigate through the project with ease
```
rails db:reset
rails dev:populate_database
```
This will also create the following users:
```
```

If instead you want to have a clean start, you could just run the following commands to seed the database
with records that would otherwise need to be created by an admin:
```
rails db:reset
rails dev:create_knowledge_fields
```

Running the following command will start the server, which will then be accessible through http://localhost:3000
```
rails server
```

## Test Suite

Tests can be run using the following command
```
rspec
```

## Tools used during development

- [Ruby](https://github.com/ruby/ruby) - 3.0.0

- [Rails](https://github.com/rails/rails) - 6.1.4

- SQLite3 - 1.4.2

- [RSpec](https://github.com/rspec/rspec-rails) - 3.10

- [Capybara](https://github.com/teamcapybara/capybara) - 3.35.3

- [Devise](https://github.com/heartcombo/devise) - 4.8.0

- [Bootstrap](https://github.com/twbs/bootstrap) - 5.1

- [SolarGraph](https://github.com/castwide/solargraph) - 0.44.0
