require 'rails_helper'

feature 'Пользователь может создавать ответ на странице вопроса', %q(
  Пользователь может добавлять ответ на вопрос,
  Чтобы поделиться своим опытом
) do

  given(:question) { create(:question) }

  describe 'Аутентифицированный пользователь', js: true do
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

    scenario 'может прикреплять файлы к своему ответу' do
      fill_in 'Your answer', with: 'Some answer text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Add answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

  end

  scenario 'Неаутентифицированному пользователю недоступна форма ввода ответов' do
    visit question_path(question)
    expect(page).to have_no_content('Your answer')
    expect(page).to have_no_content('Add answer')
  end

end
