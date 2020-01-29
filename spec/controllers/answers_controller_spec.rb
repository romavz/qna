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

    def post_create
      post :create, params: { question_id: question, answer: answer_attributes }
    end

    context 'with valid attributes' do
      it 'saves a new answer in database' do
        expect { post_create }.to change { question.answers.count }.by(1)
      end

      it 'redirects to show view' do
        expect(post_create).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      let(:answer_attributes) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post_create }.to_not(change { question.answers.count })
      end

      it 're-renders new view' do
        expect(post_create).to render_template :new
      end
    end
  end
end
