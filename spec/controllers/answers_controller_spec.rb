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
    context 'by guest' do
      let(:answer_attributes) { attributes_for(:answer) }
      subject { post :create, params: { question_id: question, answer: answer_attributes } }

      include_examples "don't changes answers count"
      include_examples 'redirects to login path'
    end

    context 'by authenticated user' do
      before { login(user) }
      let(:answer_attributes) { attributes_for(:answer) }

      subject { post :create, params: { question_id: question, answer: answer_attributes }, format: :js }

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
          expect { response }.to_not change(answer, :body)
        end

        include_examples 'returns status: Forbidden'
      end
    end
  end

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
