namespace :export_and_delete do
  desc 'exports small Street Cafes into CSV and expunges them'
  task small_street_cafes: :environment do
    exporter = CafeExporter.new(StreetCafe.cafes_by_size('small'))
    csv = exporter.export_to_csv
    File.write("small-cafes-#{Date.today}.csv", csv)
    exporter.expunge_from_database
    puts 'Small Street Cafes exported and expunged from the database!'
  end
end
