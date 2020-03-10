$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(event){
    event.preventDefault();
    $(this).hide();
    var answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).removeClass('hidden');
  });
});

