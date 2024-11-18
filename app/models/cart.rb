class Cart
  attr_reader :items

  def initialize(session)
    @session = session
    @session[:cart] ||= {}
    @items = @session[:cart]
  end

  def add_item(portion_order)
    item_id = portion_order.portion.id.to_s

    if @items.key?(item_id)
      @items[item_id]['quantity'] += portion_order.quantity
    else
      @items[item_id] = {
        'portion_name' => portion_order.portion.name,
        'item_name' => portion_order.portion.item.name,
        'quantity' => portion_order.quantity,
        'observation' => portion_order.observation,
        'price' => portion_order.portion.price
      }
    end
  end

  def remove_item(portion_id)
    @items.delete(portion_id.to_s)
  end

  def clear
    @items = {}
    @session[:cart] = {}
  end

  def total_price
    @items.sum { |_, item| item['price'].to_f * item['quantity'].to_i }
  end
end
