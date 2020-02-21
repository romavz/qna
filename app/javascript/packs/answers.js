$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).removeClass('hidden');
  });

  // Альтернативный способ вырезания удаленных ответов(без использования destroy.js.erb)
  // $('.answers').on('ajax:success', '.destroy-answer', function(event){
  //   $(this).closest('.answer').remove();
  // });
});

