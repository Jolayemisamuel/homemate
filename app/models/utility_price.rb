class UtilityPrice < ApplicationRecord
  belongs_to :utility

  def readable_price
    price + '/' + unit
  end

  def unit
    usage_based? ? usage_unit : length_unit
  end
end
