require 'rails_helper'

feature 'Гость может зарегистрироваться в системе', %q(
  Как Гость,
  Я хочу зарегистрироваться в системе,
  Чтобы иметь возможность войти в нее.
) do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario %q(
    Когда Гость вводит незарегистрированный email,
    То успешно проходит регистрацию
  ) do
    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: 'qwe123456'
    fill_in 'Password confirmation', with: 'qwe123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario %q(
    Когда Гость вводит уже зарегистрированный email,
    То получает сообщение с отказом регистрации
  ) do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content '1 error prohibited this user from being saved:'
    expect(page).to have_content 'Email has already been taken'
  end
end
