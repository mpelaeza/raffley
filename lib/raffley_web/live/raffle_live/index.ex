defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.Components.BannerComponents
  import RaffleyWeb.Components.BadgeComponents

  def mount(_params, _session, socket) do
    socket = socket
              |> assign(form: to_form(%{}))
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    socket = socket
             |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
             |> assign(form: to_form(params))

    {:noreply, socket}
  end


  attr :raffle, Raffley.Raffles.Raffle, required: true
  attr :id, :string, required: true

  def card(assigns) do
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">
        <img src={@raffle.image_path} alt="">
          <h2>{@raffle.prize}</h2>
          <div class="details">
            <div class="price">
              ${@raffle.ticket_price}/ ticket
            </div>
            <.badge status={@raffle.status} />
          </div>
        </div>
      </.link>
    """
  end

  attr :form, :map, required: true

  def filter_form(assigns) do
    ~H"""
          <.form for={@form} phx-change="filter">
      <.input
        type="text"
        field={@form[:q]}
        placeholder="Search raffles..."
        autocomplete="off"
        phx-debounce="300"
        class="search-input"
      />
      <.input
        type="select"
        prompt="Status"
        field={@form[:status]}
        options={["Upcoming": "upcoming" ,"Open": "open", "Closed": "closed"]}
        />
      <.input
        type="select"
        prompt="Sort by"
        field={@form[:sort_by]}
        options={[
          Prize: "prize",
          "Price: Low to High": "ticket_price",
          "Price: High to Low": "-ticket_price"
        ]}
        />
        <.link patch={~p"/raffles"} class="clear-filters">
          Clear
        </.link>
    </.form>

    """
  end

  def handle_event("filter", params, socket) do
    socket = socket
             |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
             |> assign(form: to_form(params))

    params = params 
             |> Map.take(~w(q status sort_by))
             |> Map.reject(fn {_k, v} -> v in [nil, ""] end)


    socket = push_patch(socket, to: ~p"/raffles?#{params}")
    {:noreply, socket}
  end

end
