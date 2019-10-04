class CafeCategorizer
  def initialize(cafe)
    @cafe = cafe
  end

  def add_category_to_cafe
    case cafe.post_code[0..3]
    when "LS1 "
      categorize_ls1
    when "LS2 "
      categorize_ls2
    else
      cafe.category = 'other'
    end
    cafe.save
  end

  private

  def calculate_percentile
    chair_values = StreetCafe.where("post_code LIKE 'LS2%'").order(:number_of_chairs).pluck(:number_of_chairs)
    index_at_50th_perc = (1/2.0)*(chair_values.count + 1) - 1
    cafe_index = chair_values.index(cafe.number_of_chairs)
    if cafe_index < index_at_50th_perc
      @fiftieth_percentile_or_above = false
    else
      @fiftieth_percentile_or_above = true
    end
  end

  def categorize_ls2
    calculate_percentile
    case @fiftieth_percentile_or_above
    when false
      cafe.category = 'ls2 small'
    when true
      cafe.category = 'ls2 large'
    end
  end

  def categorize_ls1
    case cafe.number_of_chairs
    when 0..9
      cafe.category = 'ls1 small'
    when 10..99
      cafe.category = 'ls1 medium'
    else
      cafe.category = 'ls1 large'
    end
  end

  attr_reader :cafe
end
