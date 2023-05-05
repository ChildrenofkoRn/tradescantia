import consumer from "./consumer"

document.addEventListener("turbolinks:load", function(){

  if (this.subscription) {
    consumer.subscriptions.remove(this.subscription);
    this.subscription = null;
    consumer.disconnect();
    console.log("Remove subscription and disconnect");
  }

  const reviews = document.querySelector('.table.reviews > tbody');
  const params = new Proxy(new URLSearchParams(window.location.search), {
    get: (searchParams, prop) => searchParams.get(prop),
  });

  if (reviews && !params.page) {
    this.subscription = consumer.subscriptions.create("ReviewsChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("Connected to ReviewsChannel");
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("Disconnected from ReviewsChannel");
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        if (reviews.childElementCount >= 16) {
          reviews.removeChild(reviews.lastElementChild);
        }
        reviews.firstElementChild.insertAdjacentHTML("afterend", data);
      }
    });
  }

})
