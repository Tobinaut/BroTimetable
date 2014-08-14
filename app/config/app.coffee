env = require 'config/environment'

if env.get('isDevelopment')
  options =
    LOG_TRANSITIONS:                false
    LOG_TRANSITIONS_INTERNAL:       false
    LOG_STACKTRACE_ON_DEPRECATION:  false
    LOG_BINDINGS:                   false
    LOG_VIEW_LOOKUPS:               false
    LOG_ACTIVE_GENERATION:          false

  Ember.RSVP.configure 'onerror', (error) ->
    if Ember.typeOf(error) is 'object'
      message = error?.message or 'No error message'
      Ember.Logger.error("RSVP Error: #{message}")
      Ember.Logger.error(error?.stack)
      Ember.Logger.error(error?.object)
    else
      Ember.Logger.error 'RSVP Error', error

  # Log view render times to the console
  Ember.STRUCTURED_PROFILE = false

  Ember.Logger.debug(
    "Running in the %c#{env.get('name')}%c environment", 'color: red;', ''
  )
else
  options = {}

module.exports = Ember.Application.create(options)
