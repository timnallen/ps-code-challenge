require 'rails_helper'

describe CafeExporter, type: :model do
  it 'export_to_csv' do
    sc1 = StreetCafe.create(name: 'Fake cafe', street_address: '123 Fake', post_code: 'LS1 456', number_of_chairs: 2, category: 'ls1 small')
    sc2 = StreetCafe.create(name: 'Other', street_address: '456 Fake', post_code: 'LS2 111', number_of_chairs: 1, category: 'ls2 small')

    ce = CafeExporter.new([sc1, sc2])
    exported_csv = ce.export_to_csv
    expected_csv = File.read('./spec/fixtures/fake.csv')

    expect(exported_csv).to eq(expected_csv)
  end

  it 'expunge_from_database' do
    sc1 = StreetCafe.create(name: 'Fake cafe', street_address: '123 Fake', post_code: 'LS1 456', number_of_chairs: 2, category: 'ls1 small')
    sc2 = StreetCafe.create(name: 'Other', street_address: '456 Fake', post_code: 'LS2 111', number_of_chairs: 1, category: 'ls2 small')
    sc3 = StreetCafe.create(name: 'Other Other', street_address: '789 Fake', post_code: 'LS1 111', number_of_chairs: 7, category: 'ls1 small')

    ce = CafeExporter.new([sc1, sc2])
    ce.expunge_from_database

    expect(StreetCafe.all).to eq([sc3])
  end
end
