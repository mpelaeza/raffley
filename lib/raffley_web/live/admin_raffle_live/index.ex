defmodule RaffleyWeb.AdminRaffleLive.Index do
  use RaffleyWeb, :live_view
  import RaffleyWeb.Components.BadgeComponents

  alias Raffley.Admin

  def mount(_params, _session, socket) do
    socket = socket 
             |> assign(:page_title, "Listing Raffles")
             |> stream(:raffles, Admin.list_raffles())
    {:ok, socket}
  end


  def render(assigns) do 
    ~H"""
    <div class="admin-index">
      <.button phx-click={
      JS.toggle(
         to: "#joke",
         in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
        out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
        time: 300
      )}>
        Toggle joke
      </.button>
      <div id="joke" class="joke hidden">
        What's your favorite drink?
      </div>
      <.header class="mt-6">
        {@page_title}
        <:actions>
          <.link
            class="button"
            navigate={~p"/admin/raffles/new"}>
            New Raffle
          </.link>
      </:actions>
      </.header>

      <.table 
        id="raffles"
        rows={@streams.raffles}
        row_click = {fn {_dom_id, raffle} -> JS.navigate(~p"/raffles/#{raffle}") end}
      >
        <:col label="Prize" :let={{_dom_id, raffle}}>
          <.link navigate={~p"/raffles/#{raffle}"}>
            <%= raffle.prize %>
          </.link>
        </:col>
        <:col label="Status" :let={{_dom_id, raffle}}>
          <.badge status={raffle.status} />
        </:col>
        <:col label="Ticket price" :let={{_dom_id, raffle}}>
          {raffle.ticket_price}
        </:col>
        <:action :let={{_dom_id, raffle}}>
          <.link navigate={~p"/admin/raffles/#{raffle}/edit"}>
            Edit
          </.link>
        </:action>
        <:action :let={{dom_id, raffle}}>
          <.link phx-click={delete_and_hide(dom_id, raffle)}
            data-confirm="Are you sure?">
            Delete
          </.link>
        </:action>

      </.table>
    </div>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Admin.get_raffle!(id)
    {:ok, _} = Admin.delete_raffle(raffle)


    {:noreply, stream_delete(socket, :raffles, raffle)}
  end

  def delete_and_hide(dom_id, raffle) do
    JS.push("delete", value: %{id: raffle.id}) 
    |> JS.hide(to: "##{dom_id}",
      transition: "fade-out",
      time: 300)
  end

end
