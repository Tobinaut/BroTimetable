LOWER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 0, m: 0, s: 0, ms: 0})
UPPER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 23, m: 59, s: 59, ms: 999})
KEY_EVENTS = {
  38: 'arrowUp'
  40: 'arrowDown'
}
UPPER_TIME_BOUND = UPPER_TIME_BOUND.toDate()
LOWER_TIME_BOUND = LOWER_TIME_BOUND.toDate()

App.TimeEditorComponent = Ember.Component.extend
  actions:
    acceptChanges: ->
      if @get('suggestionList')[@get('currentIndex')] != undefined
        value = @get('suggestionList')[@get('currentIndex')].text
        current_time = moment(@get('suggestionList')[@get('currentIndex')].text, 'HH:mm')
        current_time.year(2000)
        current_time.month(0)
        current_time.dayOfYear(1)
        @set('timeInput', current_time.format('HH:mm'))
        @set('time', current_time.toDate())
        @set('currentIndex', 0)

        focusedInput = @$().find('input')
        inputs = focusedInput.closest('.timetable-editor').find('input[type=text]')
        if inputs.index(focusedInput) == inputs.length - 1
          focusedInput.blur()
        else
          inputs.eq( inputs.index(focusedInput)+ 1 ).focus()
      else
        @set('timeInput', @get('formattedTime'))

    pickTime: (time, key) ->
      current_time = moment(time, 'HH:mm')
      current_time.year(2000)
      current_time.month(0)
      current_time.dayOfYear(1)
      @set('timeInput', time)
      @set('time', current_time.toDate())
      @set('dropdownVisible', false)#set dropdown unvisible

    setDropdownVisible: ->
      @set('dropdownVisible', true)

    setDropdownUnVisible: ->
      @set('dropdownVisible', false)
      #не работает PicлTime, так как dropdownListскрывается раньше
      #чем происхоит выбор, нужно фиксить
      # var self = this
      # setTimeout(function() {
      #   self.set('dropdownVisible', false)
      # }, 100)
  #
  #suggection list properties
  #
  lowerTimeBound: LOWER_TIME_BOUND
  upperTimeBound: UPPER_TIME_BOUND

  lowerTimeBound: (->
    timetable = @get('timetable')
    day = @get('day')
    if @get('flag') == 'from'
      if day.objectAt(day.indexOf(timetable) - 1) == undefined
        LOWER_TIME_BOUND
      else
        moment(day.objectAt(day.indexOf(timetable) - 1).close_at).add(@get('granulation'), 'm').toDate()
    else#to
      moment(timetable.open_at).add(@get('granulation'), 'm').toDate()
  ).property('time', 'pickTime', 'dropdownVisible')

  upperTimeBound: (->
    timetable = @get('timetable')
    day = @get('day')
    if @get('flag') == 'to'
      if day.objectAt(day.indexOf(timetable) + 1) == undefined
        UPPER_TIME_BOUND
      else
        moment(day.objectAt(day.indexOf(timetable) + 1).open_at).toDate()
    else#from
      moment(timetable.close_at).toDate()

  ).property('time', 'pickTime', 'dropdownVisible')

  availableTimeValues: (->
    timeIntervals = []
    today = moment(@get('lowerTimeBound'))
    while today.isBefore(moment(@get('upperTimeBound')))
      timeIntervals.push(moment(today).format('HH:mm'))
      today = today.add(@get('granulation'), 'm')
    timeIntervals
  ).property('lowerTimeBound', 'upperTimeBound')


  suggestionList: (->
    timeInput = @get('timeInput')
    self = this
    @get('availableTimeValues')
    .filter (item, index, enumerable) ->
      item.indexOf(timeInput) != -1
    .map (item, index) ->
      text: item
      isActive: index == self.get('currentIndex')
  ).property('timeInput', 'availableTimeValues', 'currentIndex')

  #
  #input properties
  #
  formattedTime: (->
    time = moment(@get('time'))
    time.format('HH:mm')
  ).property('time'),

  timeInput: Ember.computed.oneWay('formattedTime')
  #
  #dropdown properties
  #
  dropdownVisible: false

  currentIndex: 0

  # isSelectedTime: (->
  #  true
  # ).property('currentIndex'),
  #
  #обработка стрелок вверх и вниз
  #
  init: ->
    @_super(arguments...)
    @on("keyUp", @, @interpretKeyEvents)

  interpretKeyEvents: (event) ->
    map = KEY_EVENTS
    method = map[event.keyCode]
    if method
      this[method](event)
    else
      @_super(event)

  arrowUp: (event) ->
    if @get('currentIndex') != 0
      @set('currentIndex', @get('currentIndex') - 1)

  arrowDown: (event) ->
    if @get('currentIndex') != @get('suggestionList').length - 1
      @set('currentIndex', @get('currentIndex') + 1)