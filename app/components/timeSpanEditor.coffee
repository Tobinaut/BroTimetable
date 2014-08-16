App.TimeSpanEditorComponent = Ember.Component.extend
  actions:
    deleteSpan: (day) ->
      obj = this.get('timetable')
      this.get('timetables').removeObject(obj)

  canBeDeleted: false

  canBeDeleted: (->
    return this.get('day.length') > 1;
  ).property()