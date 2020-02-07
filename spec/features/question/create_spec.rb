require 'rails_helper'

feature 'Только аутентифицированный пользователь может создавать вопросы', %q(
  Как Аутентифицированный пользователь системы,
  Я хочу создавать вопросы,
  Чтобы получать на них ответы
 ) do
  given(:user) { create(:user) }

  def visit_questions_page
    visit questions_path
    click_on 'Ask question'
  end

  describe 'Аутентифицированный пользователь' do
    before do
      sign_in(user)
      visit_questions_page
    end

    scenario 'задает вопрос' do
      fill_in 'Title', with: 'Some title'
      fill_in 'Body', with: 'Some question text'

      click_on 'Ask'

      expect(page).to have_content('Your question successfully created')
      expect(page).to have_content('Some title')
      expect(page).to have_content('Some question text')
    end

    scenario 'задает вопрос, с ошибками' do
      click_on 'Ask'

      expect(page).to have_content('error(s) detected:')
    end
  end

  scenario 'Неаутентифицированный пользователь задает вопрос' do
    visit_questions_page

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
