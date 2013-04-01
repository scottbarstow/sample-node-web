load 'application'

action 'show', ->
    @title = 'Confirmation'
    token = req.query.confirmation_token
    log = compound.logger

    if token
        User.findOne {where: { confirmation_token: token }}, (err, user) ->
            if err || !user
                flash 'error', t('passport.failure.invalid_token')
                redirect pathTo.signin
            else
                user.confirmation_token = null
                user.confirmed_at = Date.now()
                user.save (err) ->
                    if err
                        flash 'error', 'Application Error'
                        log.write 'User save(during confirmation) error: ' + err

                        redirect pathTo.signin
                    else
                        req.login user, (err) ->
                            if err
                                log.write 'User save(during login) error: ' + err
                                flash 'error', t('failure.application')
                                redirect pathTo.signin
                            else
                                flash 'info', t('passport.confirmations.confirmed')
                                redirect pathTo.home
    else
        flash 'error', t('passport.failure.invalid_token')
        redirect pathTo.signin


action 'resend_show', ->
    @title = 'Resend confirmation instructions'
    render()

action 'resend', ->
    @title = 'Resend confirmation instructions'
    log = compound.logger
    User.findOne where: {email: body.email}, (err, user) ->
        if err || !user
            flash 'error', body.email + " " + t('failure.email.not_found')
            redirect pathTo.users_confirmation_resend
        else
            unless user.confirmation_token
                flash 'error', body.email + " " + t('passport.failure.already_confirmed')
                redirect pathTo.signin
            else
                # send confirmation token
                sendEmail 'emails/registrations/confirmation',
                    confirmation_link: pathTo.users_confirmation(confirmation_token: user.confirmation_token)
                ,
                    subject: 'Sign Up Confirmation',
                    email: user.email
                , 
                (err, success) =>
                    if success
                        user.confirmation_sent_at = Date.now()
                        user.save (err) ->
                            log.write("Error after resend confirmation email: " + err) if err
                        log.write('=== Email was sent to: ' + user.email)
                    else
                        log.write('Resend confirmation nodemailer error: ' + err)

                flash 'info', t('passport.confirmations.send_instructions')
                redirect pathTo.welcome



