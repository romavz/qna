require 'rails_helper'

feature 'Пользователь может создавать вопрос', %q(
  Как пользователь системы,
  Я хочу создавать вопросы,
  Чтобы получать на них ответы
 ) do

  before { visit new_question_path }

  scenario 'Пользователь пытается создать вопрос больше одного символа' do
    fill_in 'Title', with: 'Some title'
    fill_in 'Body', with: 'Some question text'

    click_on 'Ask'

    expect(page).to have_content('Your question successfully created')
    expect(page).to have_content('Some title')
    expect(page).to have_content('Some question text')
  end

  scenario 'Пользователь пытается создать пустой вопрос, содержащий 0 символов' do
    click_on 'Ask'

    expect(page).to have_content('error(s) detected:')
    # Пользователю показывается странице создания вопроса с сообщением об ошибках заполнения полей 
  end

end
