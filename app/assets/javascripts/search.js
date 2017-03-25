$(document).on('turbolinks:load', function() {
  console.log("Js Loading after turbolinks")
  var scoreCount = 0;
  var typeCount = 0;
  var langCount = 0;

  $('#language').on('click', function(e){
    e.preventDefault();
    langCount ++;
    ajax("lang", langCount)
  })

  $('#tweet_type').on('click', function(e){
    e.preventDefault();
    typeCount ++;
    ajax("tweet_type", typeCount)
  })

  $('#score').on('click', function(e){
    e.preventDefault();
    scoreCount ++;
    ajax("score", scoreCount)
  })

  function ajax(type, binary){
    $.ajax({
      url: '/',
      method: 'GET',
      data: {
        'search': type,
        'direction': binary % 2 == 0 ? 'DESC' : 'ASC'
            },
      dataType: 'html'
    }).success(function(data){
      $('#search-results').empty();
      $('#search-results').append(data);
    })
  }
})
