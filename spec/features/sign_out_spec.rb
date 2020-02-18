require 'rails_helper'

feature 'Пользователь может выйти из системы', %q(
  Аутентифицированный пользователь может выйти из систем,
  Чтобы завершить рабочую сессию
) do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Пользователь пытается выйти из системы' do
    click_on 'Logout'
    expect(page).to have_content('Signed out successfully.')
  end
end
