require 'rails_helper'

feature 'Пользователь может создавть ответ на странице вопроса', %q(
  Пользователь может добавлять ответ на вопрос,
  Чтобы поделиться своим опытом
) do
  
  given(:question) { Question.first }

  background do
    create_list :question, 5
    visit question_path(question)
  end

  scenario 'Пользователь добавляет ответ с текстом' do
    fill_in 'Your answer', with: 'Some answer text'
    click_on 'Add answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Some answer text'
    end
  end

  scenario 'Пользователь пытается добавить пустую строку' do
    click_on 'Add answer'
    expect(page).to have_content("Body can't be blank")
  end

end
