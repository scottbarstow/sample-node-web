bcrypt = require 'bcrypt'
crypto = require 'crypto'
utils  = require '../utils'

module.exports = (compound, User) ->
    app = compound.app

    User::isAdmin = ->
        !!@is_admin

    User::validPassword = (password) ->
        pepper = app.get('pepper')
        return bcrypt.compareSync( password + pepper, @encrypted_password)

    checkEmail = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i;

    User.validatesUniquenessOf 'email'
    User.validatesFormatOf 'email', with: checkEmail

    User::initResetPasswordToken = (next) ->
        crypto.randomBytes 15, (err, buf) =>
            if err
                console.log "Error during generating 'confirmation_token'. See: " + err
                next(err)
            else
                @reset_password_token = buf.toString('hex')
            this.save( next )

    # generate confirmation token and password
    User.beforeSave = (next) ->
        if @password 
            pepper = app.get('pepper')
            salt = bcrypt.genSaltSync( app.get 'stretches' )
            @encrypted_password = bcrypt.hashSync(@password + pepper, salt)
            
        next()

    # generate confirmation token and password
    User.beforeCreate = (next) ->
        crypto.randomBytes 15, (ex, buf) =>
            if ex
                console.log "Error during generating 'confirmation_token'. See: " + ex
            else
                @confirmation_token = buf.toString('hex')
          
            next()

    User.findOrCreateOAuth = (data, done) ->
        
        email  = data.profile.emails[0].value
        provider = data.profile.provider

        googleId = data.googleId
        facebookId = data.profile.id if provider is 'facebook'
        

        User.findOne where: {email: email}, (err, user) ->
            
            #console.log "====>" + googleId + "<====>>>> " + JSON.stringify(data.profile)

            if  user
                user.last_sign_in_at = Date.now()

                user.google_id = googleId     if googleId?
                user.facebook_id = facebookId if facebookId?

                unless user.confirmed_at
                    # confirm user
                    user.confirmed_at = Date.now()
                    user.confirmation_token = null

                user.save (err) ->
                    return done(err, user)

            else
                User.create {
                    #displayName: data.profile.displayName,
                    email:              email,
                    confirmed_at:       Date.now(),
                    confirmation_token: null,
                    google_id:          googleId,
                    facebook_id:        facebookId
                }, done



