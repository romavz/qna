require 'rails_helper'

feature 'Автор может удалять только свои вопросы', %q(
  Я как Аутентифицированный пользователь и Автор вопросов,
  Хочу удалять только свои вопросы,
  Чтобы не навредить другим пользователям
) do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:user2_question) { create(:question, user: user_2) }

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

      expect(page).to have_no_content('Delete')
    end
  end

  scenario 'Неаутентифицированный пользователь не может удалять вопросы' do
    visit question_path(question)

    expect(page).to have_no_content('Delete')
  end

end
