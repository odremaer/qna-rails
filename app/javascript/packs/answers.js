$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault()
    $(this).hide()
    let answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })

  $('.answers').on('click', '.delete-answer-link', function(e){
    e.preventDefault()
    let answerId = $(this).data('answerId')
    $.ajax({
      type: "DELETE",
      url: "/answers/" + answerId,
      data: {"method":"delete"},
    })
  })
})
