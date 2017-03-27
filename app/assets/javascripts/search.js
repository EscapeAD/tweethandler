$(document).on('turbolinks:load', function() {
  var category       = "id";
  var direction      = false;
  var filters_on     = {};
  var filters_change = "";

  $('#set-filter').on('click', function(e){
    var filter_sentiment = $('input[name=sentiment]:checked', '#filters').val();
    var filter_lang      = $('input[name=language_check]:checked', '#filters').val();
    var filter_type      = $('input[name=tweet_type]:checked', '#filters').val();
    if(filter_sentiment != undefined) filters_on['sentiment']   = (filter_sentiment)
    if(filter_lang      != undefined) filters_on['lang']        = (filter_lang)
    if(filter_type      != undefined) filters_on['tweet_type']  = (filter_type)
    ajax()
  })

  // refactor to group code
  $('.arrow').on('click', function(e){
    e.preventDefault();
    direction = !direction
    category  = $(this).attr("id")
    border($(this))
    ajax()
  })


  $('#filter-start').on('click', function(){
    $.ajax({
      url: '/filters',
      method: 'GET',
      data: {},
      dataType: 'html'
    }).success(function(data){
      if(filters_change != data){
      $('#additional-filters').empty();
      $('#additional-filters').append(data);
      filters_change = data;
    }
    })
  })

  function ajax(){
    $.ajax({
      url: '/',
      method: 'GET',
      data: {
        'search': category,
        'direction': direction ? 'ASC' : 'DESC',
        'filters_types': filters_on
            },
      dataType: 'html'
    }).success(function(data){
      $('#search-results').empty();
      $('#search-results').append(data);
    })
  }

  function border(id){
    $('.up').removeClass();
    $('.down').removeClass();
    if(direction){
      id.addClass('down');
    } else {
      id.addClass('up');
    }
  }

})
