document.addEventListener('turbolinks:load', function() {
    if (($("#messages").length)) {
        scroll();
    }
    $("#messages").on('scroll', isScrolledBottom);
    $("#notice button").on('click', scroll);
    $("#channels").on('click', function() {
        removeHidden($("#channels_wrapper")[0]);
    });
    $(".exit-btn").on('click', function() {
        location.reload();
    });
})

function scroll() {
    let messagesDom = $("#messages")[0]
    messagesDom.scrollTo(0, messagesDom.scrollHeight);
    isScrolledBottom();
}

function isScrolledBottom() {
    let messagesDom = $("#messages")[0]
    let doch = messagesDom.scrollHeight; //ページ全体の高さ
    let winh = $("#messages").innerHeight(); //ウィンドウの高さ
    let bottom = doch - winh; //ページ全体の高さ - ウィンドウの高さ = ページの最下部位置
    if (bottom <= $("#messages").scrollTop()) { //もし一番下にいたら、noticeを消す
        addHidden($("#notice")[0]);
    }
}

function addHidden(dom) {
    if (!(dom.classList.contains('hidden'))) {
        dom.classList.add("hidden");
    }
}

function removeHidden(dom) {
    if (dom.classList.contains('hidden')) {
        dom.classList.remove("hidden");
    }
}