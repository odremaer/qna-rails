require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author' do
      let(:question) { create(:question, user: user) }

      it 'deletes the file' do
        question.files.attach(
          io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename: 'rails_helper.rb'
        )
        expect { delete :destroy, params: {id: question.files.first.id} }.to change(question.files, :count).by(-1)
      end

      it 'redirects to question' do
        question.files.attach(
          io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename: 'rails_helper.rb'
        )

        delete :destroy, params: {id: question.files.first.id}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      let(:question) { create(:question) }

      it "can't delete file " do
        question.files.attach(
          io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
          filename: 'rails_helper.rb'
        )
        expect { delete :destroy, params: {id: question.files.first.id} }.to_not change(question.files, :count)
      end
    end
  end
end
