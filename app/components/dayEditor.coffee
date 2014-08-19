UPPER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 23, m: 59, s: 59, ms: 999})
UPPER_TIME_BOUND.toDate()

App.DayEditorComponent = Ember.Component.extend
  actions:
    ###
    # Удаление промежутка
    ###
    deleteSpan: (timetable) ->
      @get('timetables').removeObject(timetable)

    ###
    # Добавление нового промежутка в конец
    ###
    addSpan: (day) ->
      today = @get('grouped')
        .objectAt(day)

      open_at  = moment(today.get('lastObject.close_at'))
        .add(@get('granulation'), 'm')

      close_at = UPPER_TIME_BOUND

      newTimetable = Em.Object.create { open_at, close_at, day, date: null, is_working: true }
      @get('timetables').pushObject(newTimetable)


  groupedTimetables: null
  groupedBinding: 'groupedTimetables.groupedContent'

  canBeAdded: (->
    # TODO: сделать правильную проверку
    moment(@get('day.lastObject.close_at')).minutes() != 59
  ).property('day.lastObject.close_at')

  canBeDeleted: (->
    @get('day.length') > 1;
  ).property('day.length')

  ###
  # Переключатель работает/не работает целый день
  ###
  isWorking: ((key, value) ->
    if arguments.length > 1
      @get('day').forEach (item) =>
        item.set 'is_working', value

    @get('day').isEvery('is_working')
  ).property('day.@each.is_working')
