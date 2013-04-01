passport = require 'passport'

before 'protect from forgery', ->
    protectFromForgery 'a968d04f408758b63a6e587c150b8328f895d4ca'


before 'set current_user', ->
    @current_user = req.user
    next()

before 'set timezone', ->
  #TODO get timezone from user profile
    @timezone = "America/Los_Angeles"
    next()

before 'set analytics', ->
	@analytics_code = compound.app.config.analytics.code
	next()

# private

publish 'authorize', ->
    if !@current_user
      flash 'warn', t('failure.login_to_continue')
      req.session.returnTo = req.path
      redirect path_to.signin
    else
      next()

publish 'admin', ->
  if @current_user
    if @current_user.isAdmin()
      next()
    else
      flash 'error', t('failure.unauthorized_access')
      redirect path_to.home
  else
    flash 'error', t('failure.unauthorized_access')
    req.session.returnTo = req.path
    redirect path_to.signin
