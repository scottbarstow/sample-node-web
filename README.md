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


## License
Copyright (C) 2013 Scott Barstow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
