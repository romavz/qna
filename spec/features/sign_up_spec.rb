require 'rails_helper'

feature 'Гость может зарегистрироваться в системе', %q(
  Как Гость,
  Я хочу зарегистрироваться в системе,
  Чтобы иметь возможность войти в нее.
) do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  describe 'Когда Гость вводит незарегистрированный email' do

    background do
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: 'qwe123456'
    end

    scenario %q(
      И правильное подтверждение пароля,
      То успешно проходит регистрацию
    ) do
      fill_in 'Password confirmation', with: 'qwe123456'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario %q(
      И неправильное подтверждение пароля,
      То получает сообщение с отказом регистрации
    ) do
      fill_in 'Password confirmation', with: 'asdfghjk'
      click_on 'Sign up'

      expect(page).to have_content '1 error prohibited this user from being saved:'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end # describe

  describe 'Когда Гость вводит уже зарегистрированный email' do
    background do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end

    scenario %q(
      То получает сообщение с отказом регистрации
    ) do
      fill_in 'Password confirmation', with: user.password
      click_on 'Sign up'

      expect(page).to have_content '1 error prohibited this user from being saved:'
      expect(page).to have_content 'Email has already been taken'
    end

    scenario %q(
      И неправильнoe подтверждение пароля
      То получает сообщение с отказом регистрации
    ) do
      fill_in 'Password confirmation', with: user.password + '123'
      click_on 'Sign up'

      expect(page).to have_content '2 errors prohibited this user from being saved:'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
