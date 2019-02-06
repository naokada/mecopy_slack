$(document).on('turbolinks:load',function() {
  // let defalutDom = $("#user-search-result")[0];
  let added_users = [];
  let defaultDirectsHTML = $("#dm-user-search-result").children();

  function buildHtmlUser(user) {
      let html = `<li class="align-item_centered_flex contents__list__items" data-behavior="add_user" data-user-id="${ user.id }" data-user-name="${ user.name }">
      <img class="thumb_36" src="/assets/default_prof1-8b14ffdea934dd66890d13138fb941feeaf79a96282d2301a69545a1cb5b5ebf.png">
      <p>${ user.name }</p>
  </li>`
      return html;
  }
  function buildHtmlAddedUser(user) {
  let html = `<div data-behavior="remove_user">
  <input name='direct[user_ids][]' type='hidden' value='${ user.data('user-id') }'>
  <img src="/assets/default_prof1-8b14ffdea934dd66890d13138fb941feeaf79a96282d2301a69545a1cb5b5ebf.png">
  <p>${ user.data('user-name') }</p>
  <i class="fa fa-times"></i>
  </div>`
  return html;
  }

  function buildHTMLUnAddedUser() {
    let result =  defaultDirectsHTML.clone(true);
    // li要素に対して、もしadded_userにあったら、それをから消す。
    defaultDirectsHTML.children().each(function(i, ele) {
      let id = Number(ele.getAttribute('data-user-id'));
      if (added_users.includes(id)) {
        result.children().remove('*[data-user-id="'+id+'"]');
      }
    });
    // console.log(result[0]);
    let html = result[0];
    return html;
  }

  $("#dm-user-search-field").on("keyup", function(e) {
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
    let search_list = $("#dm-user-search-result")
    search_list.empty();

    if (input.length !== 0) {
      let users = $(data);
      users = Object.values(users);
      users.pop();
      users.forEach(function(user) {
        if (added_users.indexOf(user["id"]) == -1){
          let html = buildHtmlUser(user);
          search_list.append(html);
        }
      });
      if (users.length == 0) {
        $("#dm-user-search-result").html(buildHTMLUnAddedUser());
      }
    } else {
      $("#dm-user-search-result").html(buildHTMLUnAddedUser());
    }
  })
  .fail(function() {
    alert("ユーザー検索に失敗しました");
  })
});

$("#dm-user-search-result").on("click",'[data-behavior~=add_user]', function() {
  let added_list = $("#dm-user-added")
  let user = $(this);
  let html = buildHtmlAddedUser(user);
  added_users.push(user.data("user-id"));
  added_list.append(html);
  user.html("").css({'border':'none'});
  if (isResultEmpty()) {
    $("#dm-user-search-result").html(buildHTMLUnAddedUser());
  }
});

$("#dm-user-added").on("click", '[data-behavior~=remove_user]', function() {
  let user = $(this);

  //　added_usersは今回クリック以外のものに定義し直す
  added_users = added_users.filter(function( item ) {
    return item != user.children("input").val();
  });

  user.html("").css({'border':'none'});

  if (added_users.length == 0) {
    $("#dm-user-search-result").html(buildHTMLUnAddedUser());
  }
});
$("a.user-search-remove").on("click", function() {
  let user = $(this).parent();
  user.html("").css({'border':'none'});
});

});

function isResultEmpty() {
let children = $("#dm-user-search-result").children();
let result = true;
children.each(function(i, child) {
  if (child.style.border != "none") {
    result = false;
  }
});
return result;
}

