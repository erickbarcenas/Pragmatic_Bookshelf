defmodule PragmaticBookshelf  do
  def get_by_ship_to(orders, key, value) do
    data = Enum.filter(orders, fn item -> item.ship_to == key end)
    Enum.map(data, fn map -> Map.put(map, :percentage, value) end)
  end

  def get_items_no_modification(orders, key1, key2, value) do
    data = Enum.filter(orders, fn item -> (item.ship_to != key1 and item.ship_to != key2) end)
    Enum.map(data, fn map -> Map.put(map, :percentage, value) end)
  end

  def add_total_amount(element) do


    id = element.id
    ship_to = element.ship_to
    net_amount = element.net_amount
    percentage = element.percentage
    total_amount = net_amount + (net_amount * percentage)


    %{ id: id, ship_to: ship_to, net_amount: net_amount, total_amount: total_amount }
  end


  # main
  def main(tax_rates, orders) do
    # Se obtienen las llaves y valores
    keys = Map.keys(tax_rates)
    values = Map.values(tax_rates)
    # se comprueba que tax_rates tenga longitud 2 (en sus llaves)
    lenght = Enum.count(keys)


    if lenght == 2 do
      item_1_key = Enum.at(keys, 0)
      item_2_key = Enum.at(keys, 1)

      item_1_value = Enum.at(values, 0)
      item_2_value = Enum.at(values, 1)

      no_modifications = PragmaticBookshelf.get_items_no_modification(orders, item_1_key, item_2_key, 0.0)
      item_1_list = PragmaticBookshelf.get_by_ship_to(orders, item_1_key, item_1_value)
      item_2_list = PragmaticBookshelf.get_by_ship_to(orders, item_2_key, item_2_value)

      no_modifications = Enum.map(no_modifications, &PragmaticBookshelf.add_total_amount/1)
      new_list_1 = Enum.map(item_1_list, &PragmaticBookshelf.add_total_amount/1)
      new_list_2 = Enum.map(item_2_list, &PragmaticBookshelf.add_total_amount/1)


      get_id = fn item -> item.id end

      no_modifications ++ new_list_1 ++ new_list_2
      |> Enum.sort_by(get_id, :asc)
    else
      IO.puts("tax_rates must have only two keys")
    end
  end


end


### DEMO ###

tax_rates = %{ NC: 0.075, TX: 0.08 }

orders = [
  %{ id: 123, ship_to: :NC, net_amount: 100.00 },
  %{ id: 124, ship_to: :OK, net_amount: 35.50 },
  %{ id: 125, ship_to: :TX, net_amount: 24.00 },
  %{ id: 126, ship_to: :TX, net_amount: 44.80 },
  %{ id: 127, ship_to: :NC, net_amount: 25.00 },
  %{ id: 128, ship_to: :MA, net_amount: 10.00 },
  %{ id: 129, ship_to: :CA, net_amount: 102.00 },
  %{ id: 120, ship_to: :NC, net_amount: 50.00 }
]

PragmaticBookshelf.main(tax_rates, orders)

### Print orders ###

#orders_with_total_amount = PragmaticBookshelf.main(tax_rates, orders)
#for order <- orders_with_total_amount do
#  IO.puts("#{order.id} - #{order.ship_to} - #{order.net_amount} -#{order.total_amount}")
#end
