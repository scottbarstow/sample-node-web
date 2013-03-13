load 'application'

action 'show', ->
    @title = 'Confirmation'
    token = req.query.confirmation_token
    log = compound.logger

    if token
        User.findOne {where: { confirmation_token: token }}, (err, user) ->
            if err || !user
                flash 'error', t('passport.failure.invalid_token')
                redirect path_to.signin
            else
                user.confirmation_token = null
                user.confirmed_at = Date.now()
                user.save (err) ->
                    if err
                        flash 'error', 'Application Error'
                        log.write 'User save(during confirmation) error: ' + err

                        redirect path_to.signin
                    else
                        req.login user, (err) ->
                            if err
                                flash 'error', 'Application Error'
                                log.write 'User save(during login) error: ' + err
                                redirect path_to.signin
                            else
                                flash 'info', t('passport.confirmations.confirmed')
                                redirect path_to.phone_scripts
    else
        flash 'error', t('passport.failure.invalid_token')
        redirect path_to.signin


