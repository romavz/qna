require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  shared_examples "don't changes answers count" do
    it "don't changes answers count" do
      expect { subject }.to_not change(Answer, :count)
    end
  end

  shared_examples 'redirects to login path' do
    it 'redirects to login path' do
      expect(subject).to redirect_to(new_user_session_path)
    end
  end

  shared_examples 'returns status: Unauthorized' do
    it 'returns status: Unauthorized' do
      expect(subject).to have_http_status(:unauthorized)
    end
  end

  shared_examples 'returns status: Forbidden' do
    it 'returns status: Forbidden' do
      expect(subject).to have_http_status(:forbidden)
    end
  end

  describe 'POST #create' do
    let(:answer_attributes) { attributes_for(:answer) }
    subject { post :create, params: { question_id: question, answer: answer_attributes }, format: :js }

    context 'by guest' do
      include_examples "don't changes answers count"
      include_examples 'returns status: Unauthorized'
    end

    context 'by authenticated user' do
      before { login(user) }

      shared_examples 'renders template :create' do
        it 'renders template :create' do
          expect(subject).to render_template :create
        end
      end

      context 'with valid attributes' do
        it 'saves a new answer in database' do
          expect { subject }.to change { question.answers.count }.by(1)
          expect(assigns(:answer).errors).to be_empty
        end

        include_examples 'renders template :create'
      end

      context 'with invalid attributes' do
        let(:answer_attributes) { attributes_for(:answer, :invalid) }

        include_examples "don't changes answers count"
        include_examples 'renders template :create'

        it 'assigns answer errors' do
          subject
          expect(assigns(:answer).errors).not_to be_empty
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create :answer, question: question, user: user }

    context 'by guest' do
      subject { patch :update, params: { id: answer, answer: { body: 'edited text' } }, format: :js }

      it 'do not change answer body' do
        expect { subject }.to_not change(answer, :body)
      end
      include_examples 'returns status: Unauthorized'
    end

    context 'by authenticated user' do
      before { login(user) }

      context 'and answer belongs to user' do
        context 'with valid attributes' do
          before { patch :update, params: { id: answer, answer: { body: 'edited text' } }, format: :js }

          it 'have status :success' do
            expect(response).to have_http_status :success
          end

          it 'changed answer attributes' do
            answer.reload
            expect(answer.body).to eq 'edited text'
          end

          it 'renders template :update' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          subject { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

          it 'do not change answer body' do
            expect { subject }.to_not change(answer, :body)
          end

          it 'renders template :update' do
            expect(subject).to render_template :update
          end
        end
      end

      context 'but answer belongs to other user' do
        let!(:answer) { create :answer, question: question }
        subject { patch :update, params: { id: answer, answer: { body: 'edited text' } }, format: :js }

        it 'do not change answer body' do
          expect { subject }.to_not change(answer, :body)
        end

        include_examples 'returns status: Forbidden'
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    let!(:question) { create :question, user: user }
    let!(:prev_best_answer) { create :answer, question: question, best: true }
    let!(:answer) { create :answer, question: question }

    subject { patch :mark_as_best, params: { id: answer, format: :js } }

    context 'by guest' do
      it 'do not change answer attributes' do
        expect { subject }.to_not change(answer, :attributes)
      end

      it 'returns status: Unauthorized' do
        expect(subject).to have_http_status(:unauthorized)
      end
    end

    context 'by authenticated user' do
      before { login(user) }

      context 'question belongs to user' do
        before { subject }

        context 'with valid answer' do

          it 'assigns answer to new best answer' do
            expect(assigns(:best_answer)).to eq answer
          end

          it 'renders mark_as_best template' do
            expect(response).to render_template :mark_as_best
          end
        end

        context 'with invalid answer_id' do
          let!(:question2) { create :question }
          let!(:answer) { create :answer, question: question2 }

          it 'returns status: Forbidden' do
            expect(response).to have_http_status :forbidden
          end
        end
      end

      context 'question belongs to other user' do
        let!(:user2) { create :user }
        let!(:question) { create :question, :with_answers, user: user2 }

        it 'do not change answer attributes' do
          expect { subject }.to_not change(answer, :attributes)
        end

        it 'returns staus: Forbidden' do
          expect(subject).to have_http_status :forbidden
        end
      end

    end
  end # describe 'PATCH mark_as_best'

  describe 'DELETE #destroy' do
    context 'by guest' do
      let!(:answer) { create :answer }
      subject { delete :destroy, params: { id: answer }, format: :js }

      include_examples "don't changes answers count"
      include_examples 'returns status: Unauthorized'
    end

    context 'by authenticated user' do
      before { login(user) }
      subject { delete :destroy, params: { id: answer }, format: :js }

      context 'and answer belongs to user' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'must delete answer' do
          expect { subject }.to change(Answer, :count).by(-1)
        end

        it 'returns status: :success' do
          expect(subject).to have_http_status(:success)
        end
      end

      context 'but answer belongs to other user' do
        let(:user_2) { create :user }
        let!(:answer) { create(:answer, question: question, user: user_2) }

        include_examples "don't changes answers count"
        include_examples 'returns status: Forbidden'
      end
    end
  end

end
