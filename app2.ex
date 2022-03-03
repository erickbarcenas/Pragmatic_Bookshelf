defmodule Pragmatic_Bookshelf do
  def add_tax(order, tax_rates) do
    # [entrada] tax_rates -------> %{ NC: 0.075, TX: 0.08 }
    # [iteración] order.ship_to ---> %{ id: 123, ship_to: :NC, net_amount: 100.00 }

    # con Map.get preguntamos:
    # si en %{ id: 123, ship_to: :NC, net_amount: 100.00 } existe %{ NC: 0.075, TX: 0.08 }
    # si existe retornamos los valores de NC y TX, sino existe retorna 0
    tax = Map.get(tax_rates, order.ship_to, 0)
    Map.put(order, :total_amount, order.net_amount * (1 + tax))
  end

  def add_all_taxes(orders, tax_rates) do
    Enum.map(orders, fn order -> add_tax(order, tax_rates) end)
  end
end

