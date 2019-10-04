require 'rails_helper'

describe NameAdjuster, type: :model do
  it 'adjust_names' do
    all_bar_one = StreetCafe.create(name: 'All Bar One', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 99, category: 'ls1 medium')
    all_bar_two = StreetCafe.create(name: 'All Bar Two', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 111, category: 'ls1 large')

    name_adjuster_one = NameAdjuster.new(all_bar_one)
    name_adjuster_two = NameAdjuster.new(all_bar_two)

    name_adjuster_one.adjust_names
    name_adjuster_two.adjust_names

    results = StreetCafe.all

    expect(results[0].name).to eq('ls1 medium All Bar One')
    expect(results[1].name).to eq('ls1 large All Bar Two')
  end
end
