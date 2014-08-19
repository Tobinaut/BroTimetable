DAYS_IN_WEEK = 7

App.TimetableEditorComponent = Ember.Component.extend
  timetables: null

  granulation: 30 # minutes

  classNames: ['timetable-editor-component']

  init: ->
    @_super(arguments...)
    grouped = Em.ArrayProxy.createWithMixins Em.GroupableMixin,
      groupBy: 'day'
      content: @get('timetables')

    @set 'groupedTimetables', grouped
