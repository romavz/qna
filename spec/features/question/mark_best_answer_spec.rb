require 'rails_helper'

feature 'Автор вопроса, может отметить один ответ как лучший', %q(
  Я как Автор
  Хочу отметить один из ответов как лучший,
  Чтоб другие пользоветели видели рабочее решение
) do

  given!(:question) { create :question, :with_answers }

  scenario 'Неаутентифицированный пользователь не может отметить ответ как лучший' do
    visit question_path question
    within '.answers' do
      expect(page).to_not have_content('Mark as best')
    end
  end

  describe 'Аутентифицированный пользователь', js: true do
    given!(:user) { create :user }

    background do
      sign_in user
      visit question_path question
    end

    context 'открывает чужой вопрос' do
      scenario 'не может отметить ответ на чужой вопрос' do
        within '.answers' do
          expect(page).to_not have_content('Mark as best')
        end
      end
    end

    context 'открывает собственный вопрос' do
      given!(:question) { create :question, :with_answers, user: user }

      context 'и ни один ответ не отмечен как лучший' do

        scenario 'ни один ответ не имеет отметку лучшего' do
          expect(page).to_not have_css('.best-answer')
        end

        scenario 'у всех ответов есть ссылка для отмечания ответа как лучшего' do
          mark_links = all('a', text: 'Mark as best', visible: true).to_a
          expect(mark_links.size).to eq question.answers.size
        end
      end

      context 'и один ответ отмечен как лучший' do
        given!(:question) do
          a_question = create :question, :with_answers, user: user
          a_question.update(best_answer_id: a_question.answers.first.id)
          a_question
        end

        scenario 'ответ имеет отметку лучшего И у него скрыта ссылка для установки отметки лучшего' do
          best_answer_node = find('.best-answer')
          expect(page).to have_css('.best-answer', count: 1)
          within(best_answer_node) do
            expect(page).to_not have_content('Mark as best')
          end
        end
      end

      context 'и отмечает лучшие ответы' do
        before do
          all('.answer').each do |answer_node|
            within(answer_node) do
              click_on 'Mark as best'
              @last_marked_answer_id = answer_node[:id]
            end
          end
          sleep 1 # добавил потому-что ожидание капибары завершения ajax запросов почему-то иногда не работает
        end

        scenario %q(
          последний отмеченный ответ верхний в списке ответов
          И только он имеет отметку как лучший
          И у него скрыта ссылка для установки отметки лучшего
        ) do
          top_answer_node = all('.answer').to_a.first

          expect(top_answer_node[:id]).to eq @last_marked_answer_id
          expect(top_answer_node[:class]).to have_content('best-answer')
          expect(page).to have_css('.best-answer', count: 1)

          within(top_answer_node) do
            expect(page).to_not have_content('Mark as best')
          end
        end
      end
    end
  end
end
