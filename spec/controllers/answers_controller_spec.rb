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

      it 'redirects to question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid_answer), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

     it 're-renders show question view' do

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
      expect { delete :destroy, params: {id: answer} }.to change(Answer, :count).by(-1)
    end

    it 'does not delete answer if user is not author' do
      expect { delete :destroy, params: {id: answer} }.to_not change(Answer, :count)
    end

    it 'redirects to current question' do
      delete :destroy, params: {id: answer}
      expect(response).to redirect_to question_path(answer.question)
    end
  end
end
