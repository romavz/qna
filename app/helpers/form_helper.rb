module FormHelper
  def add_answer_form(question, answer)
    render('answers/new', question: question, answer: answer) unless current_user.nil?
  end
end
