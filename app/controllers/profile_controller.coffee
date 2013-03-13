load 'application'

before use 'authorize'

action 'show', ->
    @title = 'Profile'
    @user = @current_user
    render()

action 'new_password', ->
    @title = 'New Password'
    @user = @current_user
    render()

action 'update_password', ->
    @title = 'New Password'
    @user = user = @current_user
    @user.password = body.User.password

    if user.password != body.User.password_confirmation
        flash 'error', t('passport.failure.password_neq_confirmation')
        render 'new_password'
    else if !user.validPassword(body.User.old_password)
        flash 'error', t('passport.failure.invalid_password')
        render 'new_password'
    else if @user.password.length < 6
        if @user.errors
            @user.errors.add 'password', t('passport.failure.invalid_password_format')
        else
            @user.errors = {password: [t('passport.failure.invalid_password_format')]}

        render 'new_password'
    else
        user.save (err) ->
            respondTo (format) ->
                format.json ->
                    if err
                        send code: 500, error: user && user.errors || err
                    else
                        send code: 200, data: {email: user.email}

                format.html ->
                    if !err
                        flash 'info', 'Password was updated'
                        redirect path_to.profile
                    else
                        flash 'error', 'Password can not be updated'
                        render 'new_password'