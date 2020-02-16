require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  shared_examples "don't changes answers count" do
    it "don't changes answers count" do
      expect { subject }.to_not change(Answer, :count)
    end
  end

  context 'For guest' do
    shared_examples 'redirects to login path' do
      it 'redirects to login path' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST #create' do
      let(:answer_attributes) { attributes_for(:answer) }
      subject { post :create, params: { question_id: question, answer: answer_attributes } }

      include_examples "don't changes answers count"
      include_examples 'redirects to login path'
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create :answer }
      subject { delete :destroy, params: { id: answer } }

      include_examples "don't changes answers count"
      include_examples 'redirects to login path'
    end
  end

  context 'For authenticated user' do
    before { login(user) }

    describe 'POST #create' do
      let(:answer_attributes) { attributes_for(:answer) }

      subject { post :create, params: { question_id: question, answer: answer_attributes } }

      context 'with valid attributes' do
        it 'saves a new answer in database' do
          expect { subject }.to change { question.answers.count }.by(1)
          expect(assigns(:answer).errors).to be_empty
        end

        it 'redirects to question show view' do
          expect(subject).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        let(:answer_attributes) { attributes_for(:answer, :invalid) }

        include_examples "don't changes answers count"

        it 'renders question show view' do
          expect(subject).to render_template 'questions/show'
        end

        it 'assigns answer errors' do
          subject
          expect(assigns(:answer).errors).not_to be_empty
        end
      end
    end

    describe 'DELETE #destroy' do
      subject { delete :destroy, params: { id: answer } }

      context 'answer belongs to user' do
        let!(:answer) { create(:answer, question: question, user: user) }

        it 'must delete answer' do
          expect { subject }.to change(Answer, :count).by(-1)
        end

        it 'redirects to question show view' do
          expect(subject).to redirect_to question
        end
      end

      context 'answer belongs to other user' do
        let(:user_2) { create :user }
        let!(:answer) { create(:answer, question: question, user: user_2) }

        include_examples "don't changes answers count"

        it 'redirects to question show view' do
          expect(subject).to redirect_to question
        end
      end
    end # context 'For authenticated user'
  end

end
