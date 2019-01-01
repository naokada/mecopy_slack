document.addEventListener('turbolinks:load', function() {
    scroll();
})


function scroll() {
    let messages_dom = $("#messages")[0]
    messages_dom.scrollTo(0, messages_dom.scrollHeight);
}