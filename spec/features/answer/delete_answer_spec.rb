require 'rails_helper'

feature 'Автор может удалять только свои ответы', %q(
  Я как Аутентифицированный пользователь и Автор ответов,
  Хочу удалять только свои ответы,
  Чтобы не навредить другим пользователям
) do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Аутентифицированный пользователь' do
    background { sign_in(user) }
    scenario 'может удалить свой ответ' do
      visit question_path(question)
      within('.answers') { click_on 'Delete' }

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Your answer successfully deleted')
      expect(page).to have_no_content(answer.body)
    end

    context do
      given!(:answer) { create(:answer, question: question, user: user_2) }

      scenario 'не может удалить чужой ответ' do
        visit question_path(question)
        expect(find('.answers')).to have_no_content('Delete')
      end
    end
  end

  scenario 'Неаутентифицированный пользователь не может удалять ответы' do
    visit question_path question
    expect(find('.answers')).to have_no_content('Delete')
  end

end
