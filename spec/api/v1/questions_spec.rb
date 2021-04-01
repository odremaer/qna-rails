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
    it_should_behave_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let(:comment) { comments.first }
      let(:comment_response) { json['question']['comments'].first }

      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:link) { links.first }
      let(:link_response) { json['question']['links'].first }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      context 'comments' do
        it 'returns list of comments' do
          expect(json['question']['comments'].size).to eq 3
        end

        it 'returns comments fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      context 'links' do
        it 'returns list of comments' do
          expect(json['question']['links'].size).to eq 2
        end

        it 'returns comments fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      context 'files' do
        before do
          question.files.attach(
            io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
            filename: 'rails_helper.rb'
          )
          question.files.attach(
            io: File.open(Rails.root.join('spec', 'spec_helper.rb')),
            filename: 'spec_helper.rb'
          )
          get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
        end

        it 'returns list of files' do
          expect(json['question']['files'].size).to eq question.files.size
        end

      end
    end
  end
end
