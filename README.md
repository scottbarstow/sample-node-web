# Sample Node Web App #
This app is a sample web app which we uses as the basis for a number of other apps.

It uses CompoundJS for all of the MVC, passportJS for auth and is a basic public / private framework.

It also already works for FB and Google authentication.

## Installation Instructions ##

1. install nodejs
2. run: "sudo npm install compound -g"
3. run: "sudo npm install node-gyp -g"
4. run: "npm install -l"
5. run: cp config/config.coffee.example config/config.coffee
6. in config.coffee, configure the url for the application, your Facebook App credentials, and if wanted, your Google Analytics code.
7. run: cp config/database.coffee.example config/database.coffee and set up your connection string to Mongo
8. run: cp config/mailer.yml.example config/mailer.yml and configure your mail credentials.
9. Create initial users with: "compound sd"
10. Run app: "compound s" or "node server"