module.exports = function(compound) {

    var app    = compound.app;
    var pathTo = compound.map.pathTo;
    var User   = compound.models.User;

    var passport = require('passport')
        , LocalStrategy    = require('passport-local').Strategy
        , GoogleStrategy   = require('passport-google').Strategy
        , FacebookStrategy = require('passport-facebook').Strategy;;

    app.set('pepper', "d2372efb19bc4001daad9033159cf4c84049a9dd509e8c12cb7c16a81e8bfe281f36a9994008c8b2229c052b23f52e0db2d52e226f6c3202767fd918a82b3564");
    app.set('stretches', (compound.app.settings.env == 'test') ? 1 : 10 );

    // add new routes

    pathTo.googleAuth = function(arg){
        return '/auth/google'
    }
    pathTo.facebookAuth = function(arg){
        return '/auth/facebook'
    }

    //////////////////////////////////////
    // Local Strategy
    //////////////////////////////////////

    passport.use(new LocalStrategy({
            usernameField: 'email'
        },
        function(email, password, done) {

            User.findOne( { where: { email: email, confirmed_at: {ne: null} } }, function(err, user) {
                if (err) { return done(err); }
                if (!user) {
                    return done(null, false, { message: 'Incorrect email.' });
                }
                if (!user.validPassword(password)) {
                    return done(null, false, { message: 'Incorrect password.' });
                }
                return done(null, user);
            });
        }
    ));


    ///////////////////////////////////////
    // Google Strategy
    ///////////////////////////////////////

    passport.use(new GoogleStrategy({
        returnURL: app.config.url + 'auth/google/return',
        realm: app.config.url
      },
      function(identifier, profile, done) {
        User.findOrCreateOAuth({ googleId: identifier, profile: profile }, function(err, user) {
            done(err, user);
        });
      }
    ));

    ///////////////////////////////////////
    // Facebook Strategy
    ///////////////////////////////////////

    passport.use(new FacebookStrategy({
        clientID: app.config.facebook.app_id,
        clientSecret: app.config.facebook.app_secret,
        callbackURL: app.config.url + 'auth/facebook/callback'
      },
      function(accessToken, refreshToken, profile, done) {
        User.findOrCreateOAuth({ profile: profile }, function(err, user) {
          if (err) { return done(err); }
          done(null, user);
        });
      }
    ));

    ///////////////////////////////////////
    // serialize user to session
    ///////////////////////////////////////

    passport.serializeUser(function(user, done) {
      done(null, user.id);
    });

    passport.deserializeUser(function(id, done) {
      User.find(id, function(err, user) {
        done(err, user);
      });
    });

    //////////////////////////////////
    // Passport routes
    //////////////////////////////////

    app.post('/signin',
        passport.authenticate('local', { successReturnToOrRedirect: pathTo.home(),
                                         failureRedirect: pathTo.signin(),
                                         failureFlash: true })
    );

    // Redirect the user to Google for authentication.  When complete, Google
    // will redirect the user back to the application at
    //     /auth/google/return
    app.get( pathTo.googleAuth(), passport.authenticate('google'));

    // Google will redirect the user to this URL after authentication.  Finish
    // the process by verifying the assertion.  If valid, the user will be
    // logged in.  Otherwise, authentication has failed.
    app.get('/auth/google/return', 
      passport.authenticate('google', { successReturnToOrRedirect: pathTo.home(),
                                        failureRedirect: pathTo.signin() }));

    // Redirect the user to Facebook for authentication.  When complete,
    // Facebook will redirect the user back to the application at
    //     /auth/facebook/callback
    app.get( pathTo.facebookAuth(), passport.authenticate('facebook', {scope: 'email'}));

    // Facebook will redirect the user to this URL after approval.  Finish the
    // authentication process by attempting to obtain an access token.  If
    // access was granted, the user will be logged in.  Otherwise,
    // authentication has failed.
    app.get('/auth/facebook/callback', 
      passport.authenticate('facebook', { successReturnToOrRedirect: pathTo.home(),
                                          failureRedirect: pathTo.signin() }));


}