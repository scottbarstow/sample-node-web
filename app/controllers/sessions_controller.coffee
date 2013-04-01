load 'application'

action 'new', ->
    @title = 'Login'
    req.session.returnTo = req.query.returnTo if req.query.returnTo
    render()

action 'destroy', ->
    req.logout()
    res.redirect '/'
