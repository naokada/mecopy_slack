document.addEventListener 'turbolinks:load', ->
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", channel_id: $('#messages').data('channel_id') },
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#messages').append data['message']

    speak: (message)->
      @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior~=channel_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()