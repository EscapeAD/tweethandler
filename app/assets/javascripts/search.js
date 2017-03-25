$(document).on('turbolinks:load', function() {
  console.log("Js Loading after turbolinks")
  var score       = false;
  var tweet_type  = false;
  var language    = false;

  $('#language').on('click', function(e){
    e.preventDefault();
    language = !language;
    border('#language', language)
    ajax("language", language)
  })

  $('#tweet_type').on('click', function(e){
    e.preventDefault();
    tweet_type = !tweet_type;
    border('#tweet_type', tweet_type)
    ajax("tweet_type", tweet_type)
  })

  $('#score').on('click', function(e){
    e.preventDefault();
    score = !score;
    border('#score', score)
    ajax("score", score)
  })

  function ajax(type, binary){
    $.ajax({
      url: '/',
      method: 'GET',
      data: {
        'search': type,
        'direction': binary ? 'ASC' : 'DESC'
            },
      dataType: 'html'
    }).success(function(data){
      $('#search-results').empty();
      $('#search-results').append(data);
    })
  }

  function border(id, direction){
    $('.up').removeClass();
    $('.down').removeClass();
    if(direction){
      $(id).addClass('down');
    } else {
      $(id).addClass('up');
    }
  }
})
