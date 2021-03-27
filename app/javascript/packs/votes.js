$(document).on('turbolinks:load', function(){
  $('.vote-links > div').on('ajax:success', function(e){

    let votable = e.detail[0]
    let votableObj = votable.obj
    let votableId = votable.obj_id
    let votableRating = votable.rating

    $('.vote-rating-' + votableObj + '-' + votableId).html(votableRating)
  })
    .on('ajax:error', function(e){
      let votable = e.detail[0]
      let votableError = votable.error
      let votableObj = votable.obj
      let votableId = votable.obj_id

      $('.vote-errors-' + votableObj + '-' + votableId).html(votableError)
    })
})
