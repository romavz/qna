$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).removeClass('hidden');
  });
});