require 'rails_helper'

describe 'Visitor views homepage' do
  it 'successfully' do
    visit root_path

    expect(current_path).to eq root_path
    expect(page).to have_content('Página Inicial')
  end
end
