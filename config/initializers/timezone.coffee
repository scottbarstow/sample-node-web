path       = require 'path'
fs         = require 'fs'
timezoneJS = require 'timezone-js'

module.exports = (compound) ->
  timezoneJS.timezone.zoneFileBasePath = path.join(compound.app.root, 'config', 'tz')
  timezoneJS.timezone.transport = (opts) ->
      # No success handler, what's the point?
      if opts.async
        return if typeof opts.success isnt 'function'
        
        opts.error = opts.error || console.error
        return fs.readFile opts.url, 'utf8', (err, data) ->
          if err then opts.error(err) else opts.success(data)

      return fs.readFileSync(opts.url, 'utf8')

  timezoneJS.timezone.init()