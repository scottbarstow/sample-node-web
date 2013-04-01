load 'application'

action 'new', ->
    @title = 'Sign Up'
    @user = User(email: req.body.email)
    render()

action 'welcome', ->
    @title = 'Welcome'
    render()

action 'create', ->
    @title = 'Welcome'
    @user = User(email: req.body.email)
    @user.password = req.body.password.trim()

    if req.body.password != req.body.password_confirmation
        flash 'error', t('passport.failure.password_neq_confirmation')
        render 'new'
    else if @user.password.length < 6
        if @user.errors
            @user.errors.add 'password', t('passport.failure.invalid_password_format')
        else
            @user.errors = {password: [t('passport.failure.invalid_password_format')]}

        render 'new'
    else
        @user.save (err) =>
            if err
                render 'new'
            else
                log = compound.logger
                # send confirmation token
                sendEmail 'emails/registrations/confirmation', {
                    confirmation_link: pathTo.users_confirmation(confirmation_token: @user.confirmation_token)
                }, {
                    subject: 'Thank You For Using DIDify!', 
                    email: @user.email
                }, (err, success) =>
                    if success
                        @user.confirmation_sent_at = Date.now()
                        @user.save =>
                            log.write('=== Email was sent to: ' + @user.email);
                    else
                        log.write('Nodemailer error: ' + err)

                redirect pathTo.welcome


action 'reset_password_email_show', ->
    @title = 'Forgot your password?'
    render()

action 'reset_password_email', ->
    @title = 'Forgot your password?'
    log = compound.logger
    User.findOne where: {email: body.email}, (err, user) ->
        if err || !user
            flash 'error', body.email + " " + t('failure.email.not_found')
            redirect pathTo.reset_password_email
        else
            if user.confirmation_token
                flash 'error', body.email + " " + t('passport.failure.unconfirmed')
                redirect pathTo.users_confirmation_resend
            else
                user.initResetPasswordToken (err) ->
                    if err
                        log.write('initResetPasswordToken error: ' + err)
                        flash 'error', t('failure.application')
                        redirect pathTo.reset_password_email
                    else
                        # send confirmation token
                        sendEmail 'emails/registrations/reset_password',
                            email: user.email
                            reset_password_link: pathTo.reset_password(reset_password_token: user.reset_password_token)
                        ,
                            subject: 'Reset Password Request'
                            email: user.email
                        , 
                        (err, success) =>
                            if success
                                user.reset_password_sent_at = Date.now()
                                user.save (err) =>
                                    log.write("Error after reset password email: " + err) if err
                                log.write('=== Email was sent to: ' + user.email);
                            else
                                log.write('Reset password nodemailer error: ' + err)

                        flash 'info', t('passport.passwords.send_instructions')
                        redirect pathTo.signin

action 'reset_password_show', ->
    @title = 'Set new password'
    @reset_password_token = req.query.reset_password_token

    unless @reset_password_token
        flash 'error', t('passport.failure.invalid_token')
        redirect pathTo.reset_password_email
    else
        User.findOne where: {reset_password_token: @reset_password_token}, (err, user) ->
            if err or !user
                flash 'error', t('passport.failure.invalid_token')
                redirect pathTo.reset_password_email
            else
                @user = user
                render()

action 'reset_password', ->
    @title = 'Set new password'
    @reset_password_token = body.reset_password_token
    log = compound.logger

    unless @reset_password_token
        flash 'error', t('passport.failure.invalid_token')
        redirect pathTo.reset_password_email
    else
        User.findOne where: {reset_password_token: @reset_password_token}, (err, user) ->
            if err or !user
                flash 'error', t('passport.failure.invalid_token')
                redirect pathTo.reset_password_email
            else
                @user = user
                @user.password = body.User.password
                if body.User.password != body.User.password_confirmation
                    flash 'error', t('passport.failure.password_neq_confirmation')
                    render 'reset_password_show'
                else if @user.password.length < 6
                    if @user.errors
                        @user.errors.add 'password', t('passport.failure.invalid_password_format')
                    else
                        @user.errors = {password: [t('passport.failure.invalid_password_format')]}

                    render 'reset_password_show'
                else
                    user.reset_password_token = null
                    user.reset_password_sent_at = null
                    user.save (err) ->
                        if err
                            log.write('Save user(clean reset_password_token) error: ' + err)
                            flash 'error', t('failure.application')
                            render 'reset_password_show'
                        else
                            req.login user, (err) =>
                                if err
                                    log.write "Error during passport login: #{err}"
                                    flash 'error', t('failure.application')
                                    redirect pathTo.reset_password_email
                                else
                                    flash 'info', t('passport.passwords.updated')
                                    redirect pathTo.home

    