App.tweets = App.cable.subscriptions.create({
  channel: "TweetsChannel",
  room: 'tweets'}, {
  connected: function() {
    // Called when the subscription is ready for use on the server
    console.log('I HAVE MOTHERFKING DREAM')

  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
  }
});
