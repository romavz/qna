require 'rails_helper'

feature 'Пользователь может просматривать вопрос и ответы к нему', %q(
  Пользователь может переходить к выбранному вопросу,
  Чтоб просмотреть подробности вопроса
  И Чтобы посмотреть ответы
) do

  given!(:question) { create(:question, :with_answers) }
  given!(:answers) { question.answers }

  scenario 'Пользователь переходит на страницу вопроса' do
    visit question_path question

    expect(page).to have_content question.title
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

end
