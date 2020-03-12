require 'rails_helper'

feature 'Автор вопроса, может отметить один ответ как лучший', %q(
  Я как Автор
  Хочу отметить один из ответов как лучший,
  Чтоб другие пользоветели видели рабочее решение
) do

  context 'Неаутентифицированный пользователь' do
    given!(:question) { create :question, :with_answers }
    scenario 'не может отметить ответ как лучший' do
      visit question_path question
      within '.answers' do
        expect(page).to_not have_content('Mark as best')
      end
    end
  end

  describe 'Аутентифицированный пользователь', js: true do
    given!(:user) { create :user }

    background { sign_in user }

    context 'открывает чужой вопрос' do
      given!(:question) { create :question, :with_answers }

      background { visit question_path question }

      scenario 'не может отметить ответ на чужой вопрос' do
        within '.answers' do
          expect(page).to_not have_content('Mark as best')
        end
      end
    end

    context 'открывает собственный вопрос' do
      given!(:question) { create :question, :with_answers, user: user }

      context 'и ни один ответ не отмечен как лучший' do
        background { visit question_path question }

        scenario 'ни один ответ не имеет отметку лучшего' do
          expect(page).to_not have_css('.best-answer')
        end

        scenario 'у всех ответов есть ссылка для отмечания ответа как лучшего' do
          mark_links = all('a', text: 'Mark as best', visible: true).to_a
          expect(mark_links.size).to eq question.answers.size
        end
      end

      context 'и один ответ отмечен как лучший' do
        given!(:answer) { create :answer, question: question, best: true }

        background { visit question_path question }
        scenario 'ответ имеет отметку лучшего' do

          expect(page).to have_css('.best-answer', count: 1)
        end

        scenario 'и у него скрыта ссылка для установки отметки лучшего' do
          within('.best-answer') do
            expect(page).to_not have_content('Mark as best', :visible)
          end
        end

        scenario 'у всех остальных ответов есть ссылка для отмечания ответа как лучшего' do
          mark_links = all('a', text: 'Mark as best', visible: true).to_a
          expect(mark_links.size).to eq question.answers.size - 1
        end
      end

      context 'и по очереди отмечает ответы как лучший' do
        given!(:question) { create :question, :with_answers, answers_count: 3, user: user }
        given!(:expected_answers_ids) { question.answers.to_a.reverse!.map { |answer| answer.id.to_s } }

        background do
          visit question_path question
        end

        scenario %q(
          последний отмеченный ответ верхний в списке ответов
        ) do
          all('.answer').each do |answer_node|
            within(answer_node) do
              click_on 'Mark as best'
            end
            expect(page).to have_css('.best-answer', count: 1)
            expect(page).to have_css('.best-answer', id: answer_node[:id])
          end

          actual_answers_ids = all('.answer').to_a.map { |node| node[:id] }
          expect(find('.best-answer')[:id]).to eq actual_answers_ids.first
          expect(actual_answers_ids).to match_array expected_answers_ids
        end
      end
    end
  end
end
