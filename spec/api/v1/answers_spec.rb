require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }

    it_should_behave_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all answer fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }


    it_should_behave_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_should_behave_like 'API Commentable' do
        let(:commentable) { answer }
        let(:comment_response) { json['answer'] }
      end

      it_should_behave_like 'API Linkable' do
        let(:linkable) { answer }
        let(:link_response) { json['answer'] }
      end

      it_should_behave_like 'API Fileable' do
        let(:fileable) { answer }
        let(:file_response) { json['answer'] }
      end
    end
  end
end
