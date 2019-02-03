document.addEventListener 'turbolinks:load', ->
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", channel_id: $('#messages').data('channel_id') },
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#messages').prepend data['message']
      $('#notice p').html("未読のメッセージがあります")
      if isNoticeable() is true
        $('#notice').removeClass("hidden")

    speak: (message)->
      @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior~=channel_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()
    scroll();

isNoticeable = ->
    if $('#notice')[0].classList.contains('hidden')
      messagesDom = $("#messages")[0]
      doch = messagesDom.scrollHeight; #ページ全体の高さ
      winh = $("#messages").innerHeight(); #ウィンドウの高さ
      bottom = doch - winh; #ページ全体の高さ - ウィンドウの高さ = ページの最下部位置
      if bottom > $("#messages").scrollTop() #もし一番下にいなかったらtrueを返す
        return true
    return false


