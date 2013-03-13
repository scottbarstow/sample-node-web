load 'application'

action 'new', ->
    @title = 'Login'
    render()

action 'destroy', ->
    req.logout()
    res.redirect '/'
