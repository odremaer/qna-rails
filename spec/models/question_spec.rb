require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  describe 'best answer methods' do
    let(:first_question) { create(:question) }
    let(:second_question) { create(:question) }

    let!(:first_answer) { create(:answer, question: first_question, best_answer: true) }
    let!(:second_answer) { create(:answer, question: first_question, best_answer: true) }

    context '#have_two_best_answer?' do
      it 'should return true if question have two best answers' do
        expect(first_question).to be_have_two_best_answers
      end

      it 'should return false if question dont have two best answers' do
        expect(second_question).to_not be_have_two_best_answers
      end
    end

    context '#previous_best_answer' do
      it 'should return previous best answer' do
        expect(first_answer).to eq first_question.previous_best_answer
      end
    end
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
