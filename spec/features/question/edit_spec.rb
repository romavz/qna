require 'rails_helper'

feature 'Аутентифицированный пользователь может редактировать свои вопросы', %q(
  Как Аутентифицированный пользователь
  Я Хочу редактировать свои вопросы
  Чтобы сделать их более понятными или исправить ошибки
) do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }

  scenario 'Неаутентифицированный пользователь не может редактировать вопросы' do
    visit questions_path
    expect(page).to_not have_content 'Edit'
  end

  describe 'Аутентифицированный ползователь', js: true do
    background do
      sign_in user
      visit questions_path
    end

    context do
      given!(:question) { create :question }

      scenario 'не может редактировать чужие вопросы' do
        within('.questions') { expect(page).to_not have_content 'Edit' }
      end
    end

    scenario 'может редактировать свои вопросы' do
      within('.questions') do
        click_on 'Edit'
        fill_in 'Title', with: 'new question title'
        fill_in 'Question', with: 'new question text'
        click_on 'Save'

        expect(page).to_not have_content(question.title)
        expect(page).to have_content 'new question title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'заполняет вопрос с ошибками' do
      within('.questions') do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Question', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'может добавлять файлы во время редактирования вопроса' do
      within('.questions') do
        click_on 'Edit'
        fill_in 'Title', with: 'new question title'
        fill_in 'Question', with: 'new question text'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_content 'Files successfully added'
    end
  end

end
