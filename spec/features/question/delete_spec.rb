require 'rails_helper'

feature 'Автор может удалять только свои вопросы', %q(
  Я как Аутентифицированный пользователь и Автор вопросов,
  Хочу удалять только свои вопросы,
  Чтобы не навредить другим пользователям
) do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'Аутентифицированный пользователь', js: true do
    before { sign_in(user) }

    scenario 'может удалить свой вопрос' do
      visit questions_path
      within('.questions') { click_on 'Delete' }

      expect(current_path).to eq questions_path
      expect(page).to have_no_content(question.title)
    end

    context do
      let!(:question) { create(:question, user: user_2) }
      scenario 'не может удалить чужой вопрос' do
        visit questions_path

        expect(page).to have_no_content('Delete')
      end
    end
  end

  scenario 'Неаутентифицированный пользователь не может удалять вопросы' do
    visit questions_path

    expect(page).to have_no_content('Delete')
  end

end
