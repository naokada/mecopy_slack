$(document).on('turbolinks:load',function() {
  // let defalutDom = $("#user-search-result")[0];
  let added_users = [];
  if ($("#added_users").length === 1) {
    added_users = $("#added_users").val().slice(1, -1).split(", ").map(x => parseInt(x));
  }

  function buildHtmlUser(user) {
      let html = `<div  data-behavior="add_user" data-user-id="${ user.id }" data-user-name="${ user.name }">
      <img src="/assets/default_prof1-8b14ffdea934dd66890d13138fb941feeaf79a96282d2301a69545a1cb5b5ebf.png">
      <p>${ user.name }</p>
  </div>`
      return html;
  }
  function buildHtmlAddedUser(user) {
  let html = `<div  data-behavior="remove_user">
  <input name='channel[user_ids][]' type='hidden' value='${ user.data('user-id') }'>
  <img src="/assets/default_prof1-8b14ffdea934dd66890d13138fb941feeaf79a96282d2301a69545a1cb5b5ebf.png">
  <p>${ user.data('user-name') }</p>
  <i class="fa fa-times"></i>
  </div>`
  return html;
  }

  $("#user-search-field").on("keyup", function(e) {
    e.preventDefault();
    let input = $.trim($(this).val());

    $.ajax({
      type: 'GET',
      url: "/channels/search_user",
      data: ("keyword=" + input),
      processData: false,
      contentType: false,
      dataType: 'json'
    })

    .done(function(data) {
      let search_list = $("#user-search-result")
      search_list.empty();

      if (input.length !== 0) {
        let users = $(data);
        users = Object.values(users);
        let count = 0;
        users.pop();
        users.forEach(function(user) {
          if (added_users.indexOf(user["id"]) == -1){
            let html = buildHtmlUser(user);
            search_list.append(html);
            count++;
          }
        });
        if (count > 0) {
          removeHidden($("#user-search-result")[0]);
        }
      }
    })
    .fail(function() {
      alert("ユーザー検索に失敗しました");
    })
  });

  $("#user-search-result").on("click",'[data-behavior~=add_user]', function() {
    let added_list = $("#user-added")
    let user = $(this);
    let html = buildHtmlAddedUser(user);
    added_users.push(user.data("user-id"));
    added_list.append(html);
    user.html("").css({'border':'none'});
    if (isResultEmpty()) {
      addHidden($("#user-search-result")[0]);
    }
  });

  $("#user-added").on("click", '[data-behavior~=remove_user]', function() {
    let user = $(this);

    added_users = added_users.filter(function( item ) {
      return item != user.children("input").val();
    });

    user.html("").css({'border':'none'});
  });
  $("a.user-search-remove").on("click", function() {
    let user = $(this).parent();
    user.html("").css({'border':'none'});
  });

  function isResultEmpty() {
  let children = $("#user-search-result").children();
  let result = true;
  children.each(function(i, child) {
    if (child.style.border != "none") {
      result = false;
    }
  });
  return result;
  }
});
