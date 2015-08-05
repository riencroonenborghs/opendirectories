# Features
This repository features:
- a [Chrome extension](https://github.com/riencroonenborghs/opendirectories/tree/master/chrome/opendirectories) and a [Firefox add-on](https://github.com/riencroonenborghs/opendirectories/tree/master/firefox) for searches
- a [Chrome extension](https://github.com/riencroonenborghs/opendirectories/tree/master/chrome/opendl) and [Ruby on Rails app](https://github.com/riencroonenborghs/opendirectories/tree/master/opendl-api) for acquisition

# Compile
The search Chrome extension and Firefox add-on should work straight out of the box. 

The acquisition extension is written in coffeescript. To compile run:
```
coffee -o build -c src/*
```

# How to install

## Chrome extension
- go to `chrome://extensions`
- check `Developer mode` *(top right)*
- click `Load unpacked extension...` *(top left)*
- point it to the extension *(the folder with the manifest.json file)*
- click `Select`

## Firefox add-on
- go to `about:addons`
- click settings button next to the search field *(top right)* and select `Install Add-on From File...`
- point it to the extension *(the folder with the manifest.json file)*
- click `Open`

## Ruby on Rails app
Simple and easy steps:
- clone the repository
```
git clone https://github.com/riencroonenborghs/opendirectories/tree/master/opendl-api
```
- bundle install
```
cd opendl-api
bundle install
```
- create and migrate the database
```
rake db:create db:migrate
```
- in the Rails console: create a user
```
User.create email: "some@email.com", password: "itsasecret", password_confirmation: "itsasecret", provider: "email"
```
- fire up sidekiq (in `screen` or separate terminal)
```
screen <ENTER>
sidekiq
CTRL+A
D
```
- fire up the server
```
./bin/rails server
```
Now you're good to go
