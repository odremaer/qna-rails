require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid_question) } }.to_not change(Question, :count)
      end

     it 're-renders new view' do

       post :create, params: { question: attributes_for(:question, :invalid_question) }
       expect(response).to render_template :new
     end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question) }

    context 'author' do
      it 'deletes the question' do
        user.questions.push(question)
        expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
      end

      it 'redirects to question index ' do
        user.questions.push(question)
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      it 'does not delete question' do
        expect { delete :destroy, params: {id: question} }.to_not change(Question, :count)
      end

      it 'redirects to current question' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end
