module.exports = (compound) ->
  defaultModules = [
    'jugglingdb'
    'co-assets-compiler'
    'co-nib'
    'co-juice-mailer'
    'railway-pagination'
  ]

  developmentModules = []
  if compound.app.get('env') is 'development'
    developmentModules = [
      'jade-ext',
      'seedjs',
      'co-generators'
    ]

  unless window?
    return defaultModules.concat(developmentModules).map(require)
  else
    return []
