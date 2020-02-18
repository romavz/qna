require 'rails_helper'

feature 'Пользователь может войти в систему', %q(
  Как неаутентифицированный пользователь,
  Я хочу войти в систему,
  Чтобы иметь возможность задавать вопросы
) do

  given(:user) { create(:user) }

  background do
    visit root_path
    click_on 'Login'
  end

  describe 'Зарегистрированный пользователь пытается войти в систему' do
    background { fill_in 'Email', with: user.email }

    scenario 'Пользователь вводит правильный пароль' do
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content('Signed in successfully')
    end

    scenario 'Пользователь вводит неправильный пароль' do
      fill_in 'Password', with: user.password + '123'
      click_on 'Log in'

      expect(page).to have_content('Invalid Email or password')
    end
  end

  scenario 'Незарегистрированный пользователь пытается войти в систему' do
    fill_in 'Email', with: 'invalid_email@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password')
  end


end
