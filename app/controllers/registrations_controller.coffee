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
                mailer = require( 'railway-mailer' );

                mailer.sendEmail 'emails/registrations/confirmation', {
                    confirmation_link: pathTo.users_confirmation(confirmation_token: @user.confirmation_token)
                }, {
                    subject: 'Sign Up Confirmation', 
                    email: @user.email
                }, (err, success) =>
                    if success
                        @user.confirmation_sent_at = Date.now()
                        @user.save =>
                            log.write('=== Email was sent to: ' + @user.email);
                    else
                        log.write('Nodemailer error: ' + err)

                redirect pathTo.welcome
