require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        context 'for question' do
          it 'saves a new comment in the database' do
            expect { post :create, params: { comment: attributes_for(:comment), question_id: question } }.to change(question.comments, :count).by(1)
          end

          it 'redirects to question' do
            post :create, params: { comment: attributes_for(:comment), question_id: question }
            expect(response).to redirect_to question_path(question)
          end
        end

        context 'for answer' do
          it 'saves a new comment in the database' do
            expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer } }.to change(answer.comments, :count).by(1)
          end

          it 'redirects to question' do
            post :create, params: { comment: attributes_for(:comment), answer_id: answer }
            expect(response).to redirect_to question_path(answer.question)
          end
        end
      end

      context 'with invalid attributes' do
        context 'for question' do
          it 'does not save the comment' do
            expect { post :create, params: { comment: attributes_for(:comment, :invalid_comment), question_id: question } }.to_not change(Comment, :count)
          end

          it 'redirects to question' do
            post :create, params: { comment: attributes_for(:comment, :invalid_comment), question_id: question }
            expect(response).to redirect_to question_path(question)
          end
        end

        context 'for answer' do
          it 'does not save the comment' do
            expect { post :create, params: { comment: attributes_for(:comment, :invalid_comment), answer_id: answer } }.to_not change(Comment, :count)
          end

         it 'redirects to question' do
           post :create, params: { comment: attributes_for(:comment, :invalid_comment), answer_id: answer }
           expect(response).to redirect_to question_path(answer.question)
         end
        end
      end
    end

    context 'Unauthenticated user' do
      context 'for question' do
        it "doesn't save a comment in the database" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid_comment), question_id: question } }.to_not change(Comment, :count)
        end
      end

      context 'for answer' do
        it "doesn't save a comment in the database" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid_comment), answer_id: answer } }.to_not change(Comment, :count)
        end
      end
    end
  end
end
