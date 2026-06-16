defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  @tick_interval 5_000
  @tick_value 10


  # mount
  def mount(_params, _session, socket) do
    socket = assign(socket, tickets: 0, price: 3, page_title: "Raffle Estimator")

    # Test internal messages
    # if connected?(socket) do
      # Process.send_after(self(), :tick, @tick_interval)
    # end

    {:ok, socket}
  end
  # render
  # def render(assigns) do
  # end
  
  # handle_event
  def handle_event("add_ticket", _value, socket) do
    socket = update(socket, :tickets, &(&1 + 1))
    {:noreply, socket}
  end

  def handle_event("remove_ticket", _value, socket) do
    socket = update(socket, :tickets, &max(&1 - 1, 0))
    {:noreply, socket}
  end

  def handle_event("set_price", %{"price" => price}, socket) do
    price = String.to_integer(price)
    socket = assign(socket, :price, price)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, @tick_interval)
    {:noreply, update(socket, :tickets, &(&1 + @tick_value)) }
  end
end
