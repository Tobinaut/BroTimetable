DAYS_IN_WEEK = 7

App.TimetableEditorComponent = Ember.Component.extend

  timetables: null

  granulation: 30 # minutes

  classNames: ['timetable-editor']

  sortedTimetables: (->
    resArr = Em.ArrayProxy.create(content: [])

    for i in [0...DAYS_IN_WEEK]
      resArr.pushObject Em.ArrayProxy.create
        content: []
    @get('timetables').forEach (t) ->
      resArr.objectAt(t.get('day')).pushObject(t)
    resArr
  ).property('timetables.@each')


