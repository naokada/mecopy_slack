document.addEventListener 'turbolinks:load', ->
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", channel_id: $('#messages').data('channel_id') },
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#messages').prepend data['message']
      $('#notice p').html("未読のメッセージがあります")
      if isNoticeable is "true"
        console.log(isNoticeable)
        $('#notice').removeClass("hidden")

    speak: (message)->
      @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior~=channel_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()

isNoticeable: ->
  console.log("isNoticiable?")
  if $('#notice')[0].classList.contains('hidden')
    console.log("hiddenですよ")
  return true



