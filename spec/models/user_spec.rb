require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it 'should return true or false if user is author or not accordingly' do
    users = create_list(:user, 2)
    question = create(:question)

    users[0].questions.push(question)

    expect(users[0].is_author?(question)).to be_truthy
    expect(users[1].is_author?(question)).to be_falsey
  end
end
