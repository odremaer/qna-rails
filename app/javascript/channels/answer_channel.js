import consumer from "./consumer"
$(document).on('turbolinks:load', function(){
  if (gon.question_id){
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      connected() {
        console.log('Connected ans')
        console.log(gon.question_id)
        this.perform('follow')
      },

      received(data) {
        let template = require('./templates/answer.hbs')
        console.log(template(data))
        console.log('received', data)
        if(gon.user_id == data.user_id) return undefined;
        $('.answers').append(template(data))
      }
    })
  }else{
    return undefined;
  }
})
