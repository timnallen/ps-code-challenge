class CafeExporter
  def initialize(cafes)
    @cafes = cafes
  end

  def export_to_csv
    headers = ['Café/Restaurant Name', 'Street Address', 'Post Code', 'Number of Chairs', 'Category', 'Notes']
    attributes = ['name', 'street_address', 'post_code', 'number_of_chairs', 'category', 'notes']

    CSV.generate(headers: true) do |csv|
      csv << headers

      cafes.each do |cafe|
        csv << attributes.map{ |attr| cafe.send(attr) }
      end
    end
  end

  def expunge_from_database
    ids = cafes.map { |cafe| cafe.id }
    StreetCafe.where('id IN (?)', ids).destroy_all
  end

  private

  attr_reader :cafes
end
