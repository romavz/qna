require 'rails_helper'

feature 'Пользователь может просматривать список вопросов', %q(
  Как пользователь,
  Я хочу просматривать список заголовков вопросов,
  Чтобы выбрать интересующий вопрос
    И чтоб не отвлекаться на подробности
) do

  background do
    create_list :question, 5
  end

  given(:first_question) { Question.first }
  given(:last_question) { Question.last }

  scenario 'Пользователь переходит к списку вопросов' do
    visit questions_path

    expect(page).to have_content('Questions:')
    expect(page).to have_content(first_question.title)
    expect(page).to have_content(last_question.title)

    expect(page).to have_no_content(first_question.body)
  end

end
