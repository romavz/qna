require 'rails_helper'

feature 'Пользователь может войти в систему', %q(
  Как неаутентифицированный пользователь,
  Я хочу войти в систему,
  Чтобы иметь возможность задавать вопросы
) do

  given(:user) { create(:user) }

  scenario 'Зарегистрированный пользователь пытается войти в систему' do
    sign_in(user)
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'Незарегистрированный пользователь пытается войти в систему' do
    visit new_user_session_path
    fill_in 'Email', with: 'invalid_email@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password')
  end

end
