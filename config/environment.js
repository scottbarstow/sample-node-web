module.exports = function (compound) {

    var flash    = require('connect-flash');
    var express  = require('express');
    var passport = require('passport');
    var app      = compound.app;
    app.config   = require(app.root + '/config/config')[app.set('env')]

    app.configure(function(){
        //app.use(compound.assetsCompiler.init());
        app.use(express.static(app.root + '/public', { maxAge: 86400000 }));
        app.set('jsDirectory', '/javascripts/');
        app.set('cssDirectory', '/stylesheets/');
        app.set('cssEngine', 'stylus');
        // make sure you run `npm install browserify uglify-js`
        // app.enable('clientside');
        app.use(express.bodyParser());
        app.use(express.cookieParser('secret'));
        app.use(express.session({secret: 'secret'}));
        app.use(express.methodOverride());

        // custom settings
        //app.set('view engine', 'jade');
        app.use(flash());
        app.use(passport.initialize());
        app.use(passport.session());
        app.set('defaultLocale', 'en');

        app.use(app.router);
    });

};
