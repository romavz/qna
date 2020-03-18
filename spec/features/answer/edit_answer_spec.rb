require 'rails_helper'

feature 'Автор может редактировать свои ответы', %q(
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
      background do
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/support/controller_helpers.rb"),
          filename: 'controller_helpers.rb'
        )
        visit question_path question
      end

      scenario 'может прикреплять файлы к существующему ответу' do

        within ".answer", id: answer.id.to_s do
          click_on 'Edit'
          fill_in 'Your answer', with: 'edited answer text'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'

          expect(page).to have_link 'controller_helpers.rb'
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    context 'пытается редактировать чужой ответ' do
      given!(:answer) { create :answer, question: question, user: user_2 }

      scenario 'не может редактировать чужие ответы' do
        within '.answers' do
          expect(page).to_not have_content 'Edit'
        end
      end
    end

    context 'заполняет ответ с ошибками' do
      background do
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/support/controller_helpers.rb"),
          filename: 'controller_helpers.rb'
        )
        visit question_path question
      end

      background do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your answer', with: ''
        end
      end

      scenario 'получает сообщение об ошибках' do
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end

      scenario 'список прикрепленных файлов не поменялся' do
        within('.answers') do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'controller_helpers.rb'
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to_not have_link 'spec_helper.rb'
        end
      end
    end
  end

end
