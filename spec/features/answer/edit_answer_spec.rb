require 'rails_helper'

feature 'Автор может редактировать свои вопросы', %q(
  Как Автор,
  Я хочу редактировать свои ответы,
  Чтоб улучшить их качество
) do

  given!(:user) { create :user }
  given(:user_2) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user }

  scenario 'Неаутентифицированный пользователь не может редактировать ответы' do
    visit question_path question
    expect(page).to_not have_content 'Edit'
  end

  describe 'Аутентифицированный пользователь', js: true do
    background do
      sign_in user
      visit question_path question
    end

    scenario 'может редактировать свой ответ' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer text'
        expect(page).to_not have_selector 'textarea'
      end

    end

    context do
      given!(:answer) { create :answer, question: question, user: user_2 }

      scenario 'не может редактировать чужие ответы' do
        within '.answers' do
          expect(page).to_not have_content 'Edit'
        end
      end
    end

    scenario 'заполняет ответ с ошибками' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

end
