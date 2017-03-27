$(document).on('turbolinks:load', function() {

init()

function init(){
  var rows = $('#search-results tr').length;
  if(rows > 0){
    $('#upload-show').css('display', 'none');
  } else {
    $('#controls').css('display', 'none');
  }
}

})
