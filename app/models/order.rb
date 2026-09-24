class Order < ApplicationRecord
  ORDER_TYPES = %w[dine_in pickup delivery].freeze
  STATUSES = %w[placed in_progress ready completed].freeze

  VALID_TRANSITIONS = {
    "placed" => %w[in_progress],
    "in_progress" => %w[ready],
    "ready" => %w[completed]
  }.freeze

  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_many :status_logs, -> { order(changed_at: :asc) }, dependent: :destroy

  validates :order_type, inclusion: { in: ORDER_TYPES }
  validates :customer_name, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :table_number, presence: true, if: -> { order_type == "dine_in" }
  validates :address, presence: true, if: -> { order_type == "delivery" }

  def self.place!(order_type:, customer_name:, items:, table_number: nil, address: nil)
    transaction do
      order = create!(
        order_type: order_type,
        customer_name: customer_name,
        table_number: table_number,
        address: address,
        status: "placed"
      )

      items.each do |i|
        menu_item = MenuItem.lock.find(i.fetch(:menu_item_id))

        raise MenuItem::SoldOutError, "#{menu_item.name} ist nicht mehr verfügbar" unless menu_item.available?

        order.order_items.create!(
          menu_item: menu_item,
          quantity: i.fetch(:quantity, 1),
          price_at_order: menu_item.price
        )
      end

      order.status_logs.create!(employee: nil, status: "placed", changed_at: Time.current)
      order
    end
  end

  def advance_status!(to:, employee:)
    allowed = VALID_TRANSITIONS.fetch(status, [])
    raise ArgumentError, "ungültiger Übergang von '#{status}' zu '#{to}'" unless allowed.include?(to)

    transaction do
      update!(status: to)
      status_logs.create!(employee: employee, status: to, changed_at: Time.current)
    end
  end
end