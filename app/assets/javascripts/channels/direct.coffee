if (!App.order)
  document.addEventListener 'turbolinks:load', ->
    App.direct = App.cable.subscriptions.create { channel: "DirectChannel", direct_id: $('#messages').data('direct_id')},
      connected: ->

      disconnected: ->

      received: (data) ->
        $('#messages').prepend data['direct_message']
        $('#notice p').html("未読のメッセージがあります")
        if isNoticeable() is true
          $('#notice').removeClass("hidden")

      speak: (direct_message)->
        @perform 'speak', direct_message: direct_message

$(document).on 'keypress', '[data-behavior~=direct_speaker]', (event) ->
  if event.keyCode is 13 # return = send
    App.direct.speak event.target.value
    event.target.value = ''
    event.preventDefault()
    scroll();

isNoticeable = ->
  if $('#notice')[0].classList.contains('hidden')
    messagesDom = $("#messages")[0]
    bottom = messagesDom.scrollHeight - $("#messages").innerHeight(); #ページ全体の高さ - ウィンドウの高さ = ページの最下部位置
    if bottom > $("#messages").scrollTop() #もし一番下にいなかったらtrueを返す
      return true
  return false


