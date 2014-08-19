sysPath = require 'path'

environment = process.env.BRUNCH_ENV ? 'development'

console.log "Running Brunch in #{environment} environment"

exports.config =
  paths:
    watched: ['app', 'test', 'vendor', 'config']
  files:
    javascripts:
      joinTo:
        'scripts/app.js':
          new RegExp("^(app|config/environments/#{environment}\.coffee)")
        'scripts/vendor.js': new RegExp('^('+
            [
              'bower_components'
            ].join('|') +
          ')')

    stylesheets:
      joinTo:
        'styles/app.css': /^(app|vendor|bower_components)/

    templates:
      precompile: true
      root: 'templates'
      joinTo: 'scripts/app.js' : /^app/
      paths:
        jquery:     'bower_components/jquery/dist/jquery.min.js'
        ember:      'bower_components/ember/ember.min.js'
        handlebars: 'bower_components/handlebars/handlebars.min.js'
        emblem:     'bower_components/emblem.js/emblem.min.js'

  # allow _ prefixed templates so partials work
  conventions:
    ignored: (path) ->
      startsWith = (string, substring) ->
        string.indexOf(substring, 0) is 0
      sep = sysPath.sep
      if path.indexOf("app#{sep}templates#{sep}") is 0
        false
      else
        startsWith sysPath.basename(path), '_'

  overrides:
    production:
      optimize: true
      sourceMaps: false
      plugins: autoReload: enabled: false
