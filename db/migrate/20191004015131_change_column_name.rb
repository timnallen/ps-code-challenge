class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :street_cafes, :'café/restaurant_name', :name
  end
end
