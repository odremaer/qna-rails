require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {
    {
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  }

  describe 'GET /api/v1/questions' do
    it_should_behave_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_should_behave_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_should_behave_like 'API Commentable' do
        let(:commentable) { question }
        let(:comment_response) { json['question'] }
      end

      it_should_behave_like 'API Linkable' do
        let(:linkable) { question }
        let(:link_response) { json['question'] }
      end


      it_should_behave_like 'API Fileable' do
        let(:fileable) { question }
        let(:file_response) { json['question'] }
      end
    end
  end

  describe 'POST /api/v1/questions' do

    let(:headers) {
      {
        "ACCEPT" => "application/json"
      }
    }

    let(:access_token) { create(:access_token) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }

    let(:valid_attributes) { { access_token: access_token.token, question: attributes_for(:question) } }
    let(:invalid_attributes) { { access_token: access_token.token, question: attributes_for(:question, :invalid_question) } }

    before { do_request(method, api_path, params: valid_attributes, headers: headers) }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      context 'With valid attributes' do
        it 'saves a new question in the database' do
          expect{ do_request(method, api_path, params: valid_attributes, headers: headers) }.to change(Question, :count).by(1)
        end

        it 'return status 200' do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          expect(response).to be_successful
        end

        it 'returns question fields' do
          do_request(method, api_path, params: valid_attributes, headers: headers)

          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'With invalid attributes' do
        it "does't save new question in the database" do
          expect{ do_request(method, api_path, params: invalid_attributes, headers: headers) }.to_not change(Question, :count)
        end

        it 'returns unprocessable_entity(422)' do
          do_request(method, api_path, params: invalid_attributes, headers: headers)
          expect(response).to have_http_status(422) #unprocessable_entity
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) {
      {
        "ACCEPT" => "application/json"
      }
    }

    let(:question) { create(:question) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authorizable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'deletes the question' do
        expect {
          do_request(method, api_path, params: { access_token: access_token.token, resource_owner_id: question.user.id }, headers: headers)
        }.to change(question.user.questions, :count).by(-1)
      end

      it 'returns status 200' do
        do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) {
      {
        "ACCEPT" => "application/json"
      }
    }

    let(:question) { create(:question) }
    let(:valid_attributes) { { access_token: access_token.token, question: attributes_for(:question) } }
    let(:invalid_attributes) { { access_token: access_token.token, question: attributes_for(:question, :invalid_question) } }

    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authorizable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      context 'with valid attributes' do
        it 'edits the question' do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          question.reload
          expect(question.title).to eq valid_attributes[:question][:title]
        end

        it 'returns status 200' do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          question.reload
          expect(response).to be_successful
        end
      end
    end
  end
end
