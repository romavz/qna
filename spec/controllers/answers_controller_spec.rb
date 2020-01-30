require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:answer_attributes) { attributes_for(:answer) }

    subject { post :create, params: { question_id: question, answer: answer_attributes } }

    context 'with valid attributes' do
      it 'saves a new answer in database' do
        expect { subject }.to change { question.answers.count }.by(1)
      end

      it 'redirects to show view' do
        expect(subject).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      let(:answer_attributes) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        expect(subject).to render_template :new
      end
    end
  end
end
