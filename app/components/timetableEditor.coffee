DAYS_IN_WEEK = 7
UPPER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 23, m: 59, s: 59, ms: 999})
UPPER_TIME_BOUND.toDate()

App.TimetableEditorComponent = Ember.Component.extend
  actions:
    addSpan: (day) ->
      today = @get('sortedTimetables').objectAt(day)
      open_at = moment(today.get('lastObject').close_at).add(this.get('granulation'), 'm')
      close_at = UPPER_TIME_BOUND
      newTimetable = Em.Object.create
        open_at: open_at,
        close_at: close_at,
        day: day,
        date: null,
        is_working: true
      if(moment(today.get('lastObject').close_at).isBefore(moment.parseZone(close_at)))
        @get('timetables').pushObject(newTimetable)

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


