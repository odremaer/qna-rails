shared_examples_for 'API Linkable' do
  let!(:links) { create_list(:link, 2, linkable: linkable) }
  let(:link) { links.first }

  before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

  context 'links' do
    it 'returns list of comments' do
      expect(link_response['links'].size).to eq 2
    end

    it 'returns comments fields' do
      %w[id name url created_at updated_at].each do |attr|
        expect(link_response['links'].first[attr]).to eq link.send(attr).as_json
      end
    end
  end
end
