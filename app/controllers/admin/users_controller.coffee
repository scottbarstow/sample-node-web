load 'application'

before use 'admin'

before 'load user', ->
  User.find params.id, (err, user) =>
    if err || !user
      if !err && !user && params.format == 'json'
        return send code: 404, error: 'Not found'
      redirect pathTo.admin_users
    else
      @user = user
      next()
, only: ['destroy']

action 'index', ->
  User.all (err, users) =>
    @users = users
    @title = 'User index'
    respondTo (format) ->
      format.json ->
        send code: 200, data: users
      format.html ->
        render users: users


action 'destroy', ->
  @user.destroy (error) ->
    respondTo (format) ->
      format.json ->
        if error
          send code: 500, error: error
        else
          send code: 200
      format.html ->
        if error
          flash 'error', 'Can not destroy user'
        else
          flash 'info', 'User successfully removed'
        send "'" + path_to.admin_users + "'"
