$(document).on('turbolinks:load', function(){
App.tweets = App.cable.subscriptions.create({
  channel: "TweetsChannel",
  room: 'lobby'}, {
  connected: function() {
    // Called when the subscription is ready for use on the server
    console.log('Im connected')

  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
    console.log('bye')
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this
    $('#search-results').append(data.tweet);
    $('#pending-processed').text(data.processed)
  }
});
});
