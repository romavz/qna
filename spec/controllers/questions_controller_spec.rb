require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  shared_examples "don't changes questions count" do
    it "don't changes questions count" do
      expect { subject }.to_not change(Question, :count)
    end
  end

  shared_examples 'redirecs to login path' do
    it 'redirecs to login path' do
      expect(subject).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list :question, 2 }

    before { get :index }

    it 'poppulate questions list' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:question) { create :question, :with_answers }
    before { question.update(best_answer_id: question.answers.first.id) }
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'poppulate best answer' do
      expect(assigns(:best_answer)).to eq question.best_answer
    end

    it 'poppulate answers list without best_answer' do
      expect(assigns(:answers).to_a).to match question.answers.where.not(id: question.best_answer_id).to_a
    end
  end

  describe 'GET #new' do
    context 'by guest' do
      before { get :new }

      it 'redirecs to login path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'by authenticated user' do
      before { login(user) }
      before { get :new }

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    context 'by guest' do
      subject { post :create, params: { question: attributes_for(:question) } }

      include_examples "don't changes questions count"
      include_examples 'redirecs to login path'
    end

    context 'by authenticated user' do
      before { login(user) }

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
    end # context 'by authenticated user'

  end # describe 'POST #create'

  shared_examples 'do not change question attributes' do
    it 'do not change question attributes' do
      old_attributes = question.attributes
      question.reload

      expect(question).to have_attributes(old_attributes)
    end
  end

  describe 'PATCH mark_answer' do
    let!(:question) { create :question, user: user }
    let!(:prev_best_answer) { create :answer, question: question }
    let!(:answer) { create :answer, question: question }

    subject { patch :mark_answer, params: { id: question, answer_id: answer }, format: :js }

    context 'by guest' do
      before { subject }

      include_examples 'do not change question attributes'

      it 'returns status: Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'by authenticated user' do
      before { login(user) }
      before do
        question.update(best_answer_id: prev_best_answer.id)
        subject
      end

      context 'question belongs to user' do
        context 'with valid answer_id' do
          it 'set question best_answer_id to new answer_id' do
            question.reload
            expect(question.best_answer_id).to eq answer.id
          end

          it 'assigns answer to new best answer' do
            expect(assigns(:answer)).to eq answer
          end

          it 'renders mark_answer template' do
            expect(response).to render_template :mark_answer
          end
        end

        context 'with invalid answer_id' do
          let!(:question2) { create :question }
          let!(:answer) { create :answer, question: question2 }

          include_examples 'do not change question attributes'

          it 'returns status: Forbidden' do
            expect(response).to have_http_status :forbidden
          end
        end
      end

      context 'question belongs to other user' do
        let!(:user2) { create :user }
        let!(:question) { create :question, :with_answers, user: user2 }

        include_examples 'do not change question attributes'

        it 'returns staus: Forbidden' do
          expect(response).to have_http_status :forbidden
        end
      end

    end

  end # describe 'PATCH mark_answer'


  describe 'PATCH update' do
    let!(:question) { create :question, user: user }
    let(:new_question_attributes) { { title: 'new title', body: 'new body' } }

    subject { patch :update, params: { id: question, question: new_question_attributes }, format: :js }

    context 'by guest' do
      before { subject }

      include_examples 'do not change question attributes'

      it 'returns status: Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'by authenticated user' do
      before { login(user) }
      before { subject }

      context 'and question belongs to user' do
        context 'with valid attributes' do
          it 'changed question attributes' do
            question.reload
            expect(question).to have_attributes new_question_attributes
          end

          it 'renders template :update' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          let(:new_question_attributes) { attributes_for(:question, :invalid) }

          include_examples 'do not change question attributes'

          it 'renders template :update' do
            expect(response).to render_template :update
          end
        end
      end

      context 'but question belongs to onter user' do
        let!(:user2) { create :user }
        let!(:question) { create :question, user: user2 }

        include_examples 'do not change question attributes'

        it 'returns staus: Forbidden' do
          expect(response).to have_http_status :forbidden
        end
      end

    end
  end

  describe 'DELETE #destroy' do
    context 'by guest' do
      let!(:question) { :question }
      subject { delete :destroy, params: { id: question }, format: :js }

      include_examples "don't changes questions count"
      it 'returns status: Unauthorized' do
        expect(subject).to have_http_status :unauthorized
      end
    end

    context 'by authenticated user' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }
      subject { delete :destroy, params: { id: question }, format: :js }

      context 'and question belongs to user' do
        it 'user delete question' do
          expect { subject }.to change(Question, :count).by(-1)
        end

        it 'renders template :destroy' do
          expect(subject).to render_template :destroy
        end
      end

      context 'but question belongs to other user' do
        let(:user2) { create(:user) }
        let!(:question) { create(:question, user: user2) }

        it "user can't delete question" do
          expect { subject }.to_not change(Question, :count)
        end

        it 'returns status: Forbidden' do
          expect(subject).to have_http_status :forbidden
        end
      end

    end # context 'by authenticated user'
  end # describe 'DELETE #destroy'

end
