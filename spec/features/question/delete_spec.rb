require 'rails_helper'

feature 'Автор может удалять только свои вопросы', %q(
  Я как Аутентифицированный пользователь и Автор вопросов,
  Хочу удалять только свои вопросы,
  Чтобы не навредить другим пользователям
) do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:user2_question) { create(:question, author: user_2) }

  describe 'Аутентифицированный пользователь' do
    before { sign_in(user) }

    scenario 'может удалить свой вопрос' do
      visit question_path(question)
      click_on 'Delete'

      expect(current_path).to eq questions_path
      expect(page).to have_content('Your question successfully deleted')
    end

    scenario 'не может удалить чужой вопрос' do
      visit question_path(user2_question)
      click_on 'Delete'
      expect(page).to have_content('You can delete only your own questions')
      expect(current_path).to eq question_path(user2_question)
    end
  end

  scenario 'Неаутентифицированный пользователь не может удалять вопросы' do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content('You need to sign in or sign up before continuing')
  end

end
