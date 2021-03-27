import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  if (gon.question_id){
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      connected() {
        this.perform('follow')
      },

      received(data) {
        let template = require('./templates/answer.hbs')
        if(gon.user_id == data.user_id) return undefined;
        $('.answers').append(template(data))
      }
    })
  }else{
    return undefined;
  }
})
