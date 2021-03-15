require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

     it 'renders create template' do

       post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question }, format: :js
       expect(response).to render_template :create
     end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer) }

    it 'deletes the answer if user is author' do
      user.answers.push(answer)
      expect { delete :destroy, params: {id: answer}, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'does not delete answer if user is not author' do
      expect { delete :destroy, params: {id: answer}, format: :js }.to_not change(Answer, :count)
    end

    it 'renders destroy template' do
      delete :destroy, params: {id: answer}, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        puts answer.body
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        expect(response).to render_template :update
      end

    end
  end

end
