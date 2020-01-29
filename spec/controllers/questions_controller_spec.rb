require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post :create, params: { question: attributes_for(:question) } }

      it 'saves a new question in the database' do
        expect { subject }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        expect(subject).to redirect_to assigns(:question)
      end
    end # context

    context 'with invalid attributes' do
      subject { post :create, params: { question: attributes_for(:question, :invalid) } }

      it 'does not save the question' do
        expect { subject }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        expect(subject).to render_template :new
      end
    end # context
  end # describe 'POST #create'

end
