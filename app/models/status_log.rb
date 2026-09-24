class StatusLog < ApplicationRecord
  belongs_to :order
  belongs_to :employee, optional: true

  validates :status, presence: true
  validates :changed_at, presence: true
end