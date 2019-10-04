namespace :rename do
  desc 'rename medium and large street cafes to include category'
  task medium_and_large_street_cafes: :environment do
    medium_and_large_cafes = StreetCafe.cafes_by_size('medium', 'large')
    medium_and_large_cafes.each do |cafe|
      name_adjuster = NameAdjuster.new(cafe)
      name_adjuster.adjust_names
    end
    puts 'Medium and large street cafes renamed!'
  end
end
