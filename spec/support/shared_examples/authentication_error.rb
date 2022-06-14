require 'rails_helper'

RSpec.shared_examples 'secured' do
  it 'returns authentication error 401(:unauthorized)' do
    expect(response).to have_http_status(:unauthorized)
    expect(json['error']).to eq('You will need to login first')
  end
end