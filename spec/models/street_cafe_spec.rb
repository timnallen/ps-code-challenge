require 'rails_helper'

RSpec.describe StreetCafe, type: :model do
  describe 'class methods' do
    it '::data_by_post_code' do
      StreetCafe.create('café/restaurant_name': 'All Bar Two', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 20)
      StreetCafe.create('café/restaurant_name': 'All Bar One', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS2 3AD', number_of_chairs: 140)
      StreetCafe.create('café/restaurant_name': 'Peachy Keens', street_address: 'Electric Press Building', post_code: 'LS2 3AD', number_of_chairs: 96)

      expect(StreetCafe.data_by_post_code[0][0]).to eq('LS1 5BN')
      expect(StreetCafe.data_by_post_code[0][1]).to eq(1)
      expect(StreetCafe.data_by_post_code[0][2]).to eq(20)
      expect(StreetCafe.data_by_post_code[0][3]).to eq(20)
      expect(StreetCafe.data_by_post_code[0][4]).to eq("7.81")
      expect(StreetCafe.data_by_post_code[0][5]).to eq('All Bar Two')

      expect(StreetCafe.data_by_post_code[1][0]).to eq('LS2 3AD')
      expect(StreetCafe.data_by_post_code[1][1]).to eq(2)
      expect(StreetCafe.data_by_post_code[1][2]).to eq(236)
      expect(StreetCafe.data_by_post_code[1][3]).to eq(140)
      expect(StreetCafe.data_by_post_code[1][4]).to eq("92.19")
      expect(StreetCafe.data_by_post_code[1][5]).to eq('All Bar One')
    end

    it 'data_by_category' do
      StreetCafe.create('café/restaurant_name': 'All Bar Two', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 20, category: 'ls1 medium')
      StreetCafe.create('café/restaurant_name': 'All Bar One', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS1 3AD', number_of_chairs: 11, category: 'ls1 medium')
      StreetCafe.create('café/restaurant_name': 'Peachy Keens', street_address: 'Electric Press Building', post_code: 'LS20 3AD', number_of_chairs: 96, category: 'other')

      # expect(StreetCafe.data_by_category[0].category).to eq('ls1 medium')
      # expect(StreetCafe.data_by_category[0].total_places).to eq(2)
      # expect(StreetCafe.data_by_category[0].total_chairs).to eq(31)
      #
      # expect(StreetCafe.data_by_category[1].category).to eq('other')
      # expect(StreetCafe.data_by_category[1].total_places).to eq(1)
      # expect(StreetCafe.data_by_category[1].total_chairs).to eq(96)

      expect(StreetCafe.data_by_category[0][0]).to eq('ls1 medium')
      expect(StreetCafe.data_by_category[0][1]).to eq(2)
      expect(StreetCafe.data_by_category[0][2]).to eq(31)

      expect(StreetCafe.data_by_category[1][0]).to eq('other')
      expect(StreetCafe.data_by_category[1][1]).to eq(1)
      expect(StreetCafe.data_by_category[1][2]).to eq(96)
    end
  end
end
