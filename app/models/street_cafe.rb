class StreetCafe < ApplicationRecord
  def self.cafes_by_size(*sizes)
    if sizes.count == 2
      where("category LIKE '%#{sizes[0]}' OR category LIKE '%#{sizes[1]}'")
    elsif sizes.count == 1
      where("category LIKE '%#{sizes[0]}'")
    else
      raise ArgumentError, "Wrong number of arguments. Expecting 1-2."
    end
  end

  def self.data_by_post_code
    ActiveRecord::Base.connection.execute('SELECT post_code,
      COUNT(street_address) as total_places,
      SUM(number_of_chairs) as total_chairs,
      MAX(number_of_chairs) as max_chairs,
      ROUND((SUM(number_of_chairs)*100.0 / (SELECT SUM(number_of_chairs) FROM street_cafes) ), 2) as chairs_pct,
      (SELECT name FROM street_cafes sc2 WHERE sc2.post_code = sc1.post_code ORDER BY number_of_chairs desc LIMIT 1) as place_with_max_chairs
      FROM street_cafes sc1
      GROUP BY post_code
      ORDER BY post_code;').values
  end

  def self.data_by_category
    ActiveRecord::Base.connection.execute('SELECT category,
      COUNT(id) as total_places,
      SUM(number_of_chairs) as total_chairs
      FROM street_cafes
      GROUP BY category
      ORDER BY category;').values
    # select('category, COUNT(id) as total_places, SUM(number_of_chairs) as total_chairs')
    # .group(:category)
    # .order(:category)
  end
end
