require 'rails_helper'

feature 'Автор может удалять только свои ответы', %q(
  Я как Аутентифицированный пользователь и Автор ответов,
  Хочу удалять только свои ответы,
  Чтобы не навредить другим пользователям
) do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  def create_answer_for(user)
    create(:answer, question: question, author: user)
  end

  describe 'Аутентифицированный пользователь' do
    background { sign_in(user) }

    scenario 'может удалить свой ответ' do
      create_answer_for(user)
      visit question_path(question)
      within('.answers') { click_on 'Delete' }

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Your answer successfully deleted')
    end

    scenario 'не может удалить чужой ответ' do
      create_answer_for(user_2)
      visit question_path(question)
      within('.answers') { click_on 'Delete' }

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('You can delete only your own answers')
    end
  end

  scenario 'Неаутентифицированный пользователь не может удалять ответы' do
    create_answer_for(user)
    visit question_path question
    within('.answers') { click_on 'Delete' }

    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

end
