require 'rails_helper'

RSpec.describe StreetCafe, type: :model do
  describe 'class methods' do
    it '::data_by_post_code' do
      StreetCafe.create('café/restaurant_name': 'All Bar One', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 20)
      StreetCafe.create('café/restaurant_name': 'All Bar One', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS2 3AD', number_of_chairs: 140)
      StreetCafe.create('café/restaurant_name': 'Peachy Keens', street_address: 'Electric Press Building', post_code: 'LS2 3AD', number_of_chairs: 96)

      expect(StreetCafe.data_by_post_code[0].post_code).to eq('LS1 5BN')
      expect(StreetCafe.data_by_post_code[0].total_places).to eq(1)
      expect(StreetCafe.data_by_post_code[0].total_chairs).to eq(20)
      expect(StreetCafe.data_by_post_code[0].chairs_pct).to eq(7.0)
      expect(StreetCafe.data_by_post_code[0].place_with_max_chairs).to eq('All Bar One')
      expect(StreetCafe.data_by_post_code[0].max_chairs).to eq(20)

      expect(StreetCafe.data_by_post_code[1].post_code).to eq('LS2 3AD')
      expect(StreetCafe.data_by_post_code[1].total_places).to eq(2)
      expect(StreetCafe.data_by_post_code[1].total_chairs).to eq(236)
      expect(StreetCafe.data_by_post_code[1].chairs_pct).to eq(92.0)
      expect(StreetCafe.data_by_post_code[1].place_with_max_chairs).to eq('All Bar One')
      expect(StreetCafe.data_by_post_code[1].max_chairs).to eq(140)
    end
  end
end
