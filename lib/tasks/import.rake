namespace :import do
  desc 'import Street Cafes from file into DB'
  task street_cafes: :environment do
    CSV.foreach('./lib/Street Cafes 2015-16.csv',
                  headers: true,
                  encoding:'iso-8859-1:utf-8',
                  converters: :all,
                  header_converters: lambda { |hdr| hdr.downcase.gsub(' ', '_') }) do |row|
      cafe_data = row.to_h
      cafe_data['notes'] = cafe_data.delete(nil)
      cafe_data['name'] = cafe_data.delete('cafï¿½/restaurant_name')
      StreetCafe.create(cafe_data)
    end
    puts 'Street Cafes imported to the database!'
  end
end
