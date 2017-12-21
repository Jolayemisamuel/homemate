class UtilityPrice < ApplicationRecord
  belongs_to :utility

  validates :name, presence: true
  validates_associated :utility
  validates :price, numericality: { greater_than: 0 }
  validate :validate_usage_unit, if: :usage_based
  validate :validate_length_unit, unless: :usage_based

  def readable_price
    price + '/' + unit
  end

  def unit
    usage_based ? usage_unit : length_unit
  end

  private

  def validate_usage_unit
    errors.add(:usage_unit, 'must not be empty') if usage_unit.empty?
    errors.add(:length_unit, 'must be empty') if length_unit.present?
  end

  def validate_length_unit
    errors.add(:length_unit, 'is not a valid length unit') unless length_unit.in?(%w[w m])
    errors.add(:usage_unit, 'must be empty') if usage_unit.present?
  end
end
