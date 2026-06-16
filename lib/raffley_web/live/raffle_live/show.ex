defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.Components.BadgeComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
  
  # after mount and before render
  def handle_params(%{"id" => id}, _url, socket) do
    raffle = Raffles.get_raffle!(id)
    socket = assign(socket, :raffle, raffle)
             |> assign(:page_title, raffle.prize)
             |> assign_async(:featured_raffles, fn ->
               {:ok, %{featured_raffles: Raffles.featured_raffle(raffle)} }
               # {:error, "Failed to load featured raffles" }
             end)
    {:noreply, socket}
  end


  def featured_raffles(assigns) do
    ~H"""
    <section>
      <h4> Featured Raffles </h4>
      <.async_result :let={result} assign={@featured_raffles}>
        <:loading>
          <div class="loading">
            <div class="spinner"/>
          </div>
        </:loading>
        <:failed :let={{:error, error}}>
          <div class="failed" >
            Boom! {error}
          </div>
        </:failed>
      <ul class="raffles">
        <li :for={raffle <- result}>
          <.link navigate={~p"/raffles/#{raffle}"} class="hover:text-zinc-900">
            <img src={raffle.image_path} alt=""/>
            {raffle.prize}
          </.link>
        </li>
      </ul>
    </.async_result>
    </section>
    """
  end

end
