shared_examples_for 'API Fileable' do
  before do
    fileable.files.attach(
      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
      filename: 'rails_helper.rb'
    )
    fileable.files.attach(
      io: File.open(Rails.root.join('spec', 'spec_helper.rb')),
      filename: 'spec_helper.rb'
    )
    do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
  end

  context 'files' do
    it 'returns list of files' do
      expect(file_response['files'].size).to eq fileable.files.size
    end
  end
end
