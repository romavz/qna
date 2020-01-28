require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

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

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload # чтоб подтянуть изменения из БД
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end # context

    context 'with invalid attributes' do
      before do
        patch :update,
              params: {
                id: question,
                question: attributes_for(:question, :invalid)
              }
      end

      it 'does not change question' do
        saved_attributes = { title: question.title, body: question.body }
        question.reload
        expect(question).to have_attributes(saved_attributes)
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end # context
  end # describe 'PATCH #update'

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    subject { delete :destroy, params: { id: question } }

    it 'delete the question' do
      expect { subject }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      expect(subject).to redirect_to questions_path
    end
  end

end
