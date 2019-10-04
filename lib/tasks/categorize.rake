namespace :categorize do
  desc 'categorize cafes by code and size'
  task street_cafes: :environment do
    cafes = StreetCafe.all
    cafes.each do |cafe|
      cc = CafeCategorizer.new(cafe)
      cc.add_category_to_cafe
    end
    puts "Cafes have been categorized!"
  end
end
