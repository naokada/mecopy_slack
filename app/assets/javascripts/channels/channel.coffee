document.addEventListener 'turbolinks:load', ->
  App.channel = App.cable.subscriptions.create { channel: "ChannelChannel", channel_id: $('#messages').data('channel_id') },
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#messages').append data['message']

    speak: (message)->
      @perform 'speak', message: message

  $(document).on 'keypress', '[data-behavior~=channel_speaker]', (event) ->
    if event.keyCode is 13 # return = send
      App.channel.speak event.target.value
      event.target.value = ''
      event.preventDefault()