module.exports = App.IndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    objects = App.TimetableRaw.map (obj) ->
      obj.close_at = moment(obj.close_at).subtract(4, 'hours').toDate() # костыль с временными зонами(Z),
      obj.open_at  = moment(obj.open_at).subtract(4, 'hours').toDate()  # нужно фиксить

      Em.Object.create(obj)

    records = Ember.ArrayProxy.create
      content: Ember.A(objects)

    controller.set('records', records)


