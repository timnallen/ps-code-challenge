require 'rails_helper'

describe CafeCategorizer, type: :model do
  describe 'add_category_to_cafe' do
    it 'ls1 small' do
      all_bar_one = StreetCafe.create(name: 'All Bar One', street_address: '27 East Parade', post_code: 'LS1 5BN', number_of_chairs: 9)

      all_bar_one_categorizer = CafeCategorizer.new(all_bar_one)
      all_bar_one_categorizer.add_category_to_cafe

      expect(StreetCafe.find(all_bar_one.id).category).to eq('ls1 small')
    end

    it 'ls1 medium' do

      bar_two = StreetCafe.create(name: 'Bar Two', street_address: '123 Fake', post_code: 'LS1 5BN', number_of_chairs: 45)

      bar_two_categorizer = CafeCategorizer.new(bar_two)
      bar_two_categorizer.add_category_to_cafe

      expect(StreetCafe.find(bar_two.id).category).to eq('ls1 medium')
    end

    it 'ls1 large' do
      bar_three = StreetCafe.create(name: 'Bar Three', street_address: '123 Fake', post_code: 'LS1 5BN', number_of_chairs: 145)

      bar_three_categorizer = CafeCategorizer.new(bar_three)
      bar_three_categorizer.add_category_to_cafe

      expect(StreetCafe.find(bar_three.id).category).to eq('ls1 large')
    end

    it 'ls2 all' do
      bar_four = StreetCafe.create(name: 'Bar Four', street_address: '123 Fake', post_code: 'LS2 456', number_of_chairs: 20)
      StreetCafe.create(name: 'Bar', street_address: '123 Fake', post_code: 'LS2 456', number_of_chairs: 40)
      untouched_bar = StreetCafe.create(name: 'Bar', street_address: '123 Fake', post_code: 'LS2 456', number_of_chairs: 60)
      bar_five = StreetCafe.create(name: 'Bar Five', street_address: '123 Fake', post_code: 'LS2 456', number_of_chairs: 80)

      bar_four_categorizer = CafeCategorizer.new(bar_four)
      bar_four_categorizer.add_category_to_cafe

      bar_five_categorizer = CafeCategorizer.new(bar_five)
      bar_five_categorizer.add_category_to_cafe

      expect(StreetCafe.find(bar_four.id).category).to eq('ls2 small')
      expect(StreetCafe.find(bar_five.id).category).to eq('ls2 large')

      expect(StreetCafe.find(untouched_bar.id).category).to eq(nil)
    end

    it 'other' do
      far_bar = StreetCafe.create(name: 'Far Bar', street_address: '123 Fake', post_code: 'LS10 456', number_of_chairs: 40)

      far_bar_categorizer = CafeCategorizer.new(far_bar)
      far_bar_categorizer.add_category_to_cafe

      expect(StreetCafe.find(far_bar.id).category).to eq('other')
    end
  end
end
