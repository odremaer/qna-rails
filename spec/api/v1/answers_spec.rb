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

  describe 'POST /api/v1/question/:id/answers' do

    let(:headers) {
      {
        "ACCEPT" => "application/json"
      }
    }

    let(:access_token) { create(:access_token) }
    let(:method) { :post }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    let(:valid_attributes) { { access_token: access_token.token, answer: attributes_for(:answer) } }
    let(:invalid_attributes) { { access_token: access_token.token, answer: attributes_for(:answer, :invalid_answer) } }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'With valid attributes' do
        it 'saves a new answer in the database' do
          expect{ do_request(method, api_path, params: valid_attributes, headers: headers) }.to change(Answer, :count).by(1)
        end

        it 'return status 200' do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          expect(response).to be_successful
        end

        it 'returns answer fields' do
          do_request(method, api_path, params: valid_attributes, headers: headers)

          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end
      end

      context 'With invalid attributes' do
        it "does't save new question in the database" do
          expect{ do_request(method, api_path, params: invalid_attributes, headers: headers) }.to_not change(Answer, :count)
        end

        it 'returns unprocessable_entity(422)' do
          do_request(method, api_path, params: invalid_attributes, headers: headers)
          expect(response).to have_http_status(422) #unprocessable_entity
        end
      end
    end
  end


  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) {
      {
        "ACCEPT" => "application/json"
      }
    }

    let(:access_token) { create(:access_token) }
    let(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }


    it_behaves_like "API Authorizable"

    context 'authorized' do
      context 'author' do
        it 'deletes the answer' do
          expect {
            do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          }.to change(answer.user.answers, :count).by(-1)
        end

        it 'returns status 200' do
          do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          expect(response).to be_successful
        end
      end

      context 'not author' do
        let(:answer) { create(:answer) }
        it "doesn't deletes the answer" do
          expect {
            do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          }.to_not change(answer.user.answers, :count)
        end

        it 'returns forbidden(403)' do
          do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) {
      {
        "ACCEPT" => "application/json"
      }
    }

    let(:access_token) { create(:access_token) }
    let(:answer) { create(:answer, user_id: access_token.resource_owner_id) }

    let(:valid_attributes) { { access_token: access_token.token, answer: attributes_for(:answer) } }
    let(:invalid_attributes) { { access_token: access_token.token, answer: attributes_for(:answer, :invalid_answer) } }

    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authorizable"

    context 'authorized' do
      context 'author' do
        context 'with valid attributes' do
          it 'edits the answer' do
            do_request(method, api_path, params: valid_attributes, headers: headers)
            answer.reload
            expect(answer.body).to eq valid_attributes[:answer][:body]
          end

          it 'returns status 200' do
            do_request(method, api_path, params: valid_attributes, headers: headers)
            answer.reload
            expect(response).to be_successful
          end
        end

        context 'with invalid attributes' do
          it "doesn't edits the question" do
            do_request(method, api_path, params: invalid_attributes, headers: headers)
            answer.reload
            expect(answer.body).to_not eq invalid_attributes[:answer][:body]
          end

          it 'returns unprocessable_entity(422)' do
            do_request(method, api_path, params: invalid_attributes, headers: headers)
            answer.reload
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'not author' do
        let(:answer) { create(:answer) }

        it "doesn't edits the question" do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          answer.reload
          expect(answer.body).to_not eq valid_attributes[:answer][:body]
        end

        it 'returns forbidden(403)' do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          answer.reload
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
