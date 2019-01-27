$(document).on('turbolinks:load',function() {
  function buildHtmlChannel(channel) {
    let date = formatDate(channel.created_at);
    let html = `<a class="no_link_style" href="/channels/${channel.id}"><li class="vertical_centered_flex contents__list__items">
    <h5><span>#</span>${channel.name}</h5><p>作成日：${date}</p></li>
    </a>`
    return html;
  }

  function buildHtmlNoChannel(input) {
    let html = `<p><span>${input}</span>に当てはまるチャンネルはありませんでした。</p>`
    return html;
  }
  if(document.getElementById("channel-search-result") != null){
    let defaultChannelsHTML = document.getElementById("channel-search-result").innerHTML;

    $("#channel-search-field").on("keyup", function(e) {
    e.preventDefault();
    let input = $.trim($(this).val());

    $.ajax({
      type: 'GET',
      url: "/channels/search",
      data: ("keyword=" + input),
      processData: false,
      contentType: false,
      dataType: 'json'
    })

    .done(function(data) {
      // データを入れる箱を取得、空にする
      let joined_list = $("#joined-channels-list")
      let unjoined_list = $("#unjoined-channels-list")
      joined_list.empty();
      unjoined_list.empty();

      if (input.length !== 0) {
        if (data[0].length > 0) { //もしユーザーが参加していないチャンネル（参加できる）があった時
          data[0].forEach(function(channel) {
            unjoined_list.append(buildHtmlChannel(channel));
          });
        }
        if (data[1].length > 0) { //もしユーザーが参加しているチャンネルがあった時
          data[1].forEach(function(channel) {
            joined_list.append(buildHtmlChannel(channel));
          });
        }
        if (data[0].length === 0 && data[1].length === 0) {
          $("#channel-search-result").html(buildHtmlNoChannel(input));
        }
      } else  {
        $("#channel-search-result").html(defaultChannelsHTML);
      }
    })
    .fail(function() {
      alert("チャンネル検索に失敗しました");
    })
  });
  }

});

// Format date to year/month/date from created_at
function formatDate(created_at) {
  let date = new Date(created_at);
  let month = date.getMonth() + 1;
  return date.getFullYear() + "/" + month + "/" + date.getDate();
}

