LOWER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 0, m: 0, s: 0, ms: 0})
UPPER_TIME_BOUND = moment({y: 2000, M: 0, d: 1, h: 23, m: 59, s: 59, ms: 999})
KEY_EVENTS = {
  38: 'arrowUp'
  40: 'arrowDown'
}
UPPER_TIME_BOUND = UPPER_TIME_BOUND.toDate()
LOWER_TIME_BOUND = LOWER_TIME_BOUND.toDate()

App.TimeEditorComponent = Ember.Component.extend
  classNames: ['time-editor-component']

  actions:
    switchFocus: ->
      focusedInput = @$().find('input')
      inputs = focusedInput
        .closest('.timetable-editor')
        .find('input[type=text]')

      if inputs.index(focusedInput) == inputs.length - 1
        focusedInput.blur()
      else
        inputs.eq(inputs.index(focusedInput) + 1).focus()

    acceptReturn: ->
      choice = @get('suggestionList').objectAt(@get('currentIndex'))
      @send('pickTime', choice?.text)
      @send('switchFocus')


    pickTime: (time) ->
      current_time = moment(time, 'HH:mm')

      if current_time.isValid()
        current_time = current_time.year(2000)
          .month(0)
          .dayOfYear(1)
          .toDate()

        @set 'time', current_time
      else
        @notifyPropertyChange('time')


    setDropdownVisible: ->
      @set('dropdownVisible', true)

    setDropdownUnVisible: ->
      ###
      # TODO: очень-очень плохо
      ###
      setTimeout =>
        unless @get('isDestroyed')
          @set('dropdownVisible', false)
          @notifyPropertyChange('time')
      , 80
  ###
  # Хитрое свойство для заполнения поля при изменении времени
  ###
  formattedTime: (->
    moment(@get('time')).format('HH:mm')
  ).property('time')

  timeInputBinding: Ember.Binding.oneWay('formattedTime')

  lowerTimeBound: LOWER_TIME_BOUND
  upperTimeBound: UPPER_TIME_BOUND

  ###
  # Нижняя граница для возможного для выбора времени
  ###
  lowerTimeBound: (->
    flag      = @get 'flag'
    timetable = @get 'timetable'
    day       = @get 'day'

    if flag is 'from'
      previous = day.objectAt(day.indexOf(timetable) - 1)

      unless previous?
        LOWER_TIME_BOUND
      else
        moment(previous.get('close_at'))
          .add(@get('granulation'), 'm')
          .toDate()
    else
      moment(timetable.get('open_at'))
        .add(@get('granulation'), 'm')
        .toDate()
  ).property(
    'flag',
    'granulation',
    'timetable.open_at',
    'day.@each.open_at',
    'day.@each.close_at'
  )

  ###
  # Верхняя граница для возможного для выбора времени
  ###
  upperTimeBound: (->
    flag      = @get 'flag'
    timetable = @get 'timetable'
    day       = @get 'day'

    if flag is 'to'
      previous = day.objectAt(day.indexOf(timetable) + 1)

      unless previous?
        UPPER_TIME_BOUND
      else
        moment(previous.get('open_at'))
          .add(@get('granulation'), 'm')
          .toDate()
    else
      moment(timetable.get('close_at'))
        .add(@get('granulation'), 'm')
        .toDate()
  ).property(
    'flag',
    'granulation',
    'timetable.open_at',
    'day.@each.open_at',    'day.@each.close_at'
  )

  ###
  # Список возможных временных значений для выбора
  ###
  availableTimeValues: (->
    timeIntervals = []
    now = moment(@get('lowerTimeBound'))
    while now.isBefore(moment(@get('upperTimeBound')))
      timeIntervals.push(moment(now).format('HH:mm'))
      now = now.add(@get('granulation'), 'm')

    timeIntervals
  ).property('lowerTimeBound', 'upperTimeBound'),

  ##
  #Добавление верхней границы в список подсказок
  ##
  upperBound: (->
    if moment(@get('upperTimeBound')).minutes() == 59
      @get('availableTimeValues').push(moment(UPPER_TIME_BOUND).format('HH:mm'))
  ).observes('availableTimeValues').on('init'),

  ###
  # Список подсказок
  ###
  suggestionListText: (->
    timeInput    = @get 'timeInput'
    currentIndex = @get 'currentIndex'

    result = @get('availableTimeValues')
    .filter (item, index, enumerable) =>
      item.indexOf(timeInput) != -1
  ).property('timeInput', 'availableTimeValues', 'myProperty')

  suggestionList: (->
    currentIndex = @get('currentIndex')

    @get('suggestionListText').map (item, index) =>
      text: item
      isActive: index is currentIndex
  ).property('suggestionListText', 'currentIndex')

  ###
  # Свойства выпадающего списка подсказок
  ###
  dropdownVisible: false
  currentIndex: 0

  ###
  # Автоматическое просколливание в списке подсказок
  ###
  currentIndexHasChanged: (->
    list   = @$('.suggestion-list')
    entry  = list.find('.suggestion')
      .eq(@get('currentIndex'))

    offset = entry.position().top

    if offset >= list.innerHeight()
      list.scrollTop list.scrollTop() + offset - list.innerHeight() + 1.5 * entry.height()
    else if offset < 0
      list.scrollTop list.scrollTop() + offset

  ).observes('currentIndex')


  suggestionListHasChanged: (->
    @set('currentIndex', 0)
  ).observes('suggestionListText')

  ###
  # Обработка стрелок вверх и вниз
  ###
  init: ->
    @_super(arguments...)
    @on("keyDown", @, @interpretKeyEvents)

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

