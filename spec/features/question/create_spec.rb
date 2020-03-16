require 'rails_helper'

feature 'Только аутентифицированный пользователь может создавать вопросы', %q(
  Как Аутентифицированный пользователь системы,
  Я хочу создавать вопросы,
  Чтобы получать на них ответы
 ) do
  given(:user) { create(:user) }

  describe 'Аутентифицированный пользователь' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'задает вопрос' do
      fill_in 'Title', with: 'Some title'
      fill_in 'Body', with: 'Some question text'

      click_on 'Ask'

      expect(page).to have_content('Your question successfully created')
      expect(page).to have_content('Some title')
      expect(page).to have_content('Some question text')
    end

    scenario 'задает вопрос с ошибками' do
      click_on 'Ask'

      expect(page).to have_content('error(s) detected:')
    end

    scenario 'задает вопрос с прикреплением файла' do
      fill_in 'Title', with: 'Some title'
      fill_in 'Body', with: 'Some question text'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Неаутентифицированный пользователь задает вопрос' do
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
