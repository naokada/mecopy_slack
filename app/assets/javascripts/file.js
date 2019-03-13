$(document).on('turbolinks:load',function() {
  $('#user_avator').change(function(){
    var file = $(this).prop('files')[0];
    if(!file.type.match('image.*')){
      return;
    }
    var fileReader = new FileReader();
    fileReader.onloadend = function() {
      $(".file_field label img").attr('src', fileReader.result);
    }
    fileReader.readAsDataURL(file);
  });
  $('#file_upload').change(function(){
    var file = $(this).prop('files')[0];
    if(file.type.match('image.*')){
      var fileReader = new FileReader();
      fileReader.onloadend = function() {
        $(".file_field label img").attr('src', fileReader.result);
      }
      fileReader.readAsDataURL(file);
    }
  })
});