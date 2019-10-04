class NameAdjuster
  def initialize(cafe)
    @cafe = cafe
  end

  def adjust_names
    cafe.name = cafe.category + " " + cafe.name
    cafe.save
  end

  private

  attr_reader :cafe
end
