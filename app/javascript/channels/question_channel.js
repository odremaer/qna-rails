import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
  connected() {
    this.perform('follow')
  },

  received(data) {
    $('.questions').append(data)
  }
})
