$(document).on('turbolinks:load', function() {
  console.log("Js Loading after turbolinks")
  var score       = false;
  var tweet_type  = false;
  var language    = false;
  var filters_on  = {};

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

  $('#set-filter').on('click', function(e){
    var filter_sentiment = $('input[name=sentiment]:checked', '#filters').val();
    var filter_lang      = $('input[name=language_check]:checked', '#filters').val();
    var filter_type      = $('input[name=tweet_type]:checked', '#filters').val();
    if(filter_sentiment != undefined) filters_on['sentiment']   = (filter_sentiment)
    if(filter_lang      != undefined) filters_on['lang']        = (filter_lang)
    if(filter_type      != undefined) filters_on['tweet_type']  = (filter_type)
  })

  $('#filter-start').on('click', function(){
    $.ajax({
      url: '/filters',
      method: 'GET',
      data: {},
      dataType: 'html'
    }).success(function(data){
      $('#additional-filters').empty();
      $('#additional-filters').append(data);
    })
  })

  function ajax(type, binary){
    $.ajax({
      url: '/',
      method: 'GET',
      data: {
        'search': type,
        'direction': binary ? 'ASC' : 'DESC',
        'filters_types': filters_on
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
