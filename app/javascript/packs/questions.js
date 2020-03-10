$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(event){
    event.preventDefault();
    $(this).hide();
    var question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).removeClass('hidden');
  });

});

