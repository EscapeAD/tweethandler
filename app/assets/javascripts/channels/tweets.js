$(document).on('turbolinks:load', function(){
App.tweets = App.cable.subscriptions.create({
  channel: "TweetsChannel",
  room: 'lobby'}, {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    console.log('bye')
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this
    if(data.problem){
      $('#api-issue').text("API Error: " + data.problem);
      $('#api-issue').css('display', 'block');
    } else if (data.empty){
      $('#search-results').empty();
      $('#pending-processed').text("0");
      $('#pending').text("0");
      $('#upload-show').css('display', 'block');
      $('#controls').css('display', 'none');
    } else {
    $('#controls').css('display', 'block');
    $('#upload-show').css('display', 'none');
    $('#search-results').append(data.tweet);
    $('#pending-processed').text(data.processed);
    $('#pending-pending').text(data.pending);
    }
  }
});
});
