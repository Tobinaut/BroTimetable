UPPER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 23, m: 59, s: 59, ms: 999})
UPPER_TIME_BOUND.toDate()

App.DayEditorComponent = Ember.Component.extend
  actions:
    deleteSpan: (timetable) ->
      @get('timetables').removeObject(timetable)
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

  canBeDeleted: false

  canBeDeleted: (->
    @get('day.length') > 1;
  ).property(),

  # isWorking: false,

  isWorking: ((key, value)->
    if value
      console.log 'sdf'
      # @get('day').forEach (item) =>
        # item.is_working = value

    # @get('day').isEvery('is_working')
  ).property('day.@each.is_working')