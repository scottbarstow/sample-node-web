passport = require 'passport'

before 'protect from forgery', ->
    protectFromForgery 'a968d04f408758b63a6e587c150b8328f895d4ca'


before 'current_user', ->
    @current_user = req.user
    next()

# private

publish 'authorize', ->
    if !@current_user
        redirect path_to.signin
    else
        next()

