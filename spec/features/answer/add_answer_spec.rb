require 'rails_helper'

feature 'Пользователь может создавть ответ на странице вопроса', %q(
  Пользователь может добавлять ответ на вопрос,
  Чтобы поделиться своим опытом
) do

  given(:question) { create(:question) }

  describe 'Аутентифицированный пользователь' do
    given(:user) { create :user }

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'добавляет ответ с текстом' do
      fill_in 'Your answer', with: 'Some answer text'
      click_on 'Add answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Some answer text'
      end
    end

    scenario 'пытается добавить пустую строку' do
      click_on 'Add answer'
      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario 'Неаутентифицированный пользователь добавляет ответ' do
    visit question_path(question)
    fill_in 'Your answer', with: 'Some answer text'
    click_on 'Add answer'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

end
