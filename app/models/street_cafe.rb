class StreetCafe < ApplicationRecord
  def self.data_by_post_code
    select("post_code,
      COUNT(street_address) as total_places,
      SUM(number_of_chairs) as total_chairs,
      MAX(number_of_chairs) as max_chairs,
      ROUND((SUM(number_of_chairs)*100 / (SELECT SUM(number_of_chairs) FROM street_cafes) )) as chairs_pct,
      (SELECT \"café/restaurant_name\" FROM street_cafes WHERE number_of_chairs = (SELECT MAX(number_of_chairs) FROM street_cafes)) as place_with_max_chairs")
    .group(:post_code)
    .order(:post_code)
  end
end
