require_relative '../lib/scrapper'

RSpec.describe 'get_townhall_list' do
  it 'returns a hash of towns and their email addresses' do
    expect(get_townhall_list('https://annuaire-des-mairies.com/val-d-oise.html')).to be_a(Hash)
  end

  it 'returns a non-empty hash' do
    expect(get_townhall_list('https://annuaire-des-mairies.com/val-d-oise.html')).not_to be_empty
  end

  it 'returns a hash with non-empty values' do
    expect(get_townhall_list('https://annuaire-des-mairies.com/val-d-oise.html').values).not_to include(nil, '')
  end
end

RSpec.describe 'save_as_JSON' do
  it 'creates a JSON file' do
    save_as_JSON({ 'town1' => 'email1', 'town2' => 'email2' })
    expect(File.exist?('../../db/emails.json')).to be true
  end

  it 'creates a non-empty JSON file' do
    save_as_JSON({ 'town1' => 'email1', 'town2' => 'email2' })
    expect(File.read('../../db/emails.json')).not_to be_empty
  end
end

RSpec.describe 'save_as_csv' do
  it 'creates a CSV file' do
    save_as_csv({ 'town1' => 'email1', 'town2' => 'email2' })
    expect(File.exist?('../../db/emails.csv')).to be true
  end

  it 'creates a non-empty CSV file' do
    save_as_csv({ 'town1' => 'email1', 'town2' => 'email2' })
    expect(File.read('../../db/emails.csv')).not_to be_empty
  end
end

RSpec.describe 'menu_choice' do
  it 'calls save_as_JSON method when choice is 1' do
    expect(self).to receive(:save_as_JSON)
    menu_choice(1)
  end

  it 'calls save_as_csv method when choice is 2' do
    expect(self).to receive(:save_as_csv)
    menu_choice(2)
  end

  it 'calls save_as_spreadsheet method when choice is 3' do
    expect(self).to receive(:save_as_spreadsheet)
    menu_choice(3)
  end

  it 'calls menu_choice method when choice is invalid' do
    expect(self).to receive(:menu_choice)
    menu_choice(4)
  end
end
