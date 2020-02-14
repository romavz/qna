require 'rails_helper'

feature 'Пользователь может просматривать список вопросов', %q(
  Как пользователь,
  Я хочу просматривать список заголовков вопросов,
  Чтобы выбрать интересующий вопрос
    И чтоб не отвлекаться на подробности
) do

  given!(:questions) { create_list(:question, 2) }

  scenario 'Пользователь переходит к списку вопросов' do
    visit questions_path

    expect(page).to have_content('Questions:')
    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end

end
