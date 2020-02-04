require 'rails_helper'

feature 'Пользователь может просматривать вопрос и ответы к нему', %q(
  Пользователь может переходить к выбранному вопросу,
  Чтоб просмотреть подробности вопроса
  И Чтобы посмотреть ответы
) do

  given(:question) { Question.first }
  given(:answers) { question.answers }

  background do
    create_list :question, 5, :with_answers
  end

  scenario 'Пользователь переходит на страницу вопроса' do
    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end

end
