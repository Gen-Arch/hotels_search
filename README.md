# hotels search

## run development
### main
http://localhost:4567/hotels_search/

### rest api
http://localhost:4567/hotels_search/api

### mongo-express
http://localhost:8081

# Deplotment
- [Ruby(2.6.2)](https://www.ruby-lang.org/ja/)
- [sinatra](http://sinatrarb.com/)
- [docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

## DB
- [mongodb](https://www.mongodb.com/)
- [mongoid](https://docs.mongodb.com/mongoid/current/)

## Crawling
- [selenium](https://seleniumhq.github.io/selenium/docs/api/rb/)

# Usage
## install
```
bundle install
```

## setup

### create database
```
bundle exec rake crawling:update
```

### create systemd file(.service&.target)
```
bundle exec procsd create
```

## start
```
bundle exec procsd start
```

## stop
```
bundle exec procsd stop
```


## restart
```
bundle exec procsd restart
```

## enable service
```
bundle exec procsd enable
```

# debug

## systemd status
```
bundle exec procsd status
```

## systemd log
```
bundle exec procsd logs
```

## command list
```
Commands:
  procsd --version, -v   # Print the version
  procsd config          # Print config files based on current settings. Available types: sudoers
  procsd create          # Create and enable app services
  procsd destroy         # Stop, disable and remove app services
  procsd disable         # Disable app target
  procsd enable          # Enable app target
  procsd exec            # Run app process
  procsd help [COMMAND]  # Describe available commands or one specific command
  procsd list            # List all app services
  procsd logs            # Show app services logs
  procsd restart         # Restart app services
  procsd start           # Start app services
  procsd status          # Show app services status
  procsd stop            # Stop app services
```

