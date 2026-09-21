class MenuItem < ApplicationRecord
  DEPARTMENTS = %w[kitchen bar].freeze
  
  class SoldOutError < StandardError; end

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :department, inclusion: { in: DEPARTMENTS }

  scope :available, -> { where(available: true) }
end