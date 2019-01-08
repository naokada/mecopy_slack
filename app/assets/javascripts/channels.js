$(document).on('turbolinks:load',function() {
    // let defalutDom = $("#user-search-result")[0];

    function buildHtmlUser(user) {
        var html = `<div  data-behavior="add_user" data-user-id="${ user.id }" data-user-name="${ user.name }">
      <p>${ user.name }</p>
    </div>`
        return html;
    }
    function buildHtmlAddedUser(user) {
    var html = `<div  data-behavior="remove_user">
    <input name='channel[user_ids][]' type='hidden' value='${ user.data('user-id') }'>
    <p>${ user.data('user-name') }</p></div>`
    return html;
    }

    $("#user-search-field").on("keyup", function(e) {
    e.preventDefault();
    var input = $.trim($(this).val());

    $.ajax({
      type: 'GET',
      url: "/channels/search",
      data: ("keyword=" + input),
      processData: false,
      contentType: false,
      dataType: 'json'
    })

    .done(function(data) {
        console.log(data);
      var search_list = $("#user-search-result")
      search_list.empty();

      if (input.length !== 0) {
        var users = $(data);
        var users = Object.values(users);
        users.pop();
        users.forEach(function(user) {
          var html = buildHtmlUser(user);
          search_list.append(html);
        });
      }
    })
    .fail(function() {
      alert("ユーザー検索に失敗しました");
    })
  });

  $("#user-search-result").on("click",'[data-behavior~=add_user]', function() {
    var added_list = $("#user-added")
    var user = $(this);
    console.log(user[0]);
    var html = buildHtmlAddedUser(user);
    added_list.append(html);
  });

  $("#user-added").on("click", '[data-behavior~=remove_user]', function() {
    var user = $(this).parent();
    user.html("").css({'border':'none'});
  });
  $("a.user-search-remove").on("click", function() {
    var user = $(this).parent();
    user.html("").css({'border':'none'});
  });

//   function setDefault(dom) {
      
//   }
});