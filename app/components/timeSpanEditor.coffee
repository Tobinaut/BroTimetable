App.TimeSpanEditorComponent = Ember.Component.extend
  actions:
    deleteSpan: (day) ->
      console.log 'hey'
      obj = this.get('timetable')
      this.get('timetables').removeObject(obj)

  canBeDeleted: false

  canBeDeleted: (->
    return this.get('day.length') > 1;
  ).property()