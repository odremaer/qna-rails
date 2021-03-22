require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable  }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist?' do
    let(:question) { create(:question) }
    let(:link) { create(:link, linkable: question) }
    it 'should return true if url is gist' do
      link.url = 'https://gist.github.com/odremaer/1579b382ad42b1e48ba6cbef450689f8'
      expect(link).to be_gist
    end

    it 'should return false if url isnt gist' do
      expect(link).to_not be_gist
    end
  end
end
