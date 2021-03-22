require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }
    let(:question) { create(:question, user: user) }
    let!(:link) { create(:link, linkable: question) }

    context 'author' do
      it 'deletes the link' do
        expect { delete :destroy, params: {id: link} }.to change(Link, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: {id: link}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      let(:question) { create(:question) }

      it 'cant delete link' do
        expect { delete :destroy, params: {id: link} }.to_not change(Link, :count)
      end
    end
  end
end
