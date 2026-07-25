defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view
  alias Raffley.Raffles
  alias Raffley.Tickets
  alias Raffley.Tickets.Ticket
  import RaffleyWeb.Components.BadgeComponents

  on_mount {RaffleyWeb.UserAuth, :mount_current_scope}


  def mount(_params, _session, socket) do
    %{current_scope: current_scope} = socket.assigns
    changeset = Tickets.change_ticket(current_scope, %Ticket{user_id: current_scope.user.id})
    socket = assign(socket, :form, to_form(changeset))
    {:ok, socket}
  end
  
  # after mount and before render
  def handle_params(%{"id" => id}, _url, socket) do
    raffle = Raffles.get_raffle!(id)
    tickets = Raffles.list_tickets(raffle)
    socket = assign(socket, :raffle, raffle)
             |> stream(:tickets, tickets, reset: true)
             |> assign(:ticket_count, Enum.count(tickets))
             |> assign(:ticket_sum, Enum.sum_by(tickets, fn t -> t.price end))
             |> assign(:page_title, raffle.prize)
             |> assign_async(:featured_raffles, fn ->
               {:ok, %{featured_raffles: Raffles.featured_raffle(raffle)} }
               # {:error, "Failed to load featured raffles" }
             end)
    {:noreply, socket}
  end

  def handle_event("validate", %{"ticket" => ticket_params}, socket) do
    %{current_scope: current_scope} = socket.assigns
    changeset = Tickets.change_ticket(current_scope, %Ticket{user_id: current_scope.user.id}, ticket_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  def handle_event("buy-ticket", ticket_params, socket) do
    save_ticket(socket, ticket_params)
  end


  defp save_ticket(socket, %{"ticket" => ticket_params}) do
    %{raffle: raffle, current_scope: current_scope} = socket.assigns
    case Tickets.create_ticket(current_scope, raffle, ticket_params) do
      {:ok, ticket} ->
      changeset = Tickets.change_ticket(current_scope, %Ticket{user_id: current_scope.user.id})
      socket = socket
               |> put_flash(:info, "Ticket buyed, Thanks!")
               |> assign(:form, to_form(changeset))
               |> stream_insert(:tickets, ticket, at: 0)
               |> update(:ticket_count , &(&1 + 1))
               |> update(:ticket_sum , &(&1 + ticket.price))
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  attr :tickets, :list, required: true

  def purchased_tickets(assigns) do
    ~H"""
    <div id="tickets" phx-update="stream">
        <.ticket :for={{dom_id, ticket} <- @tickets} id={dom_id} ticket={ticket}/>
    </div>
    """
  end

  attr :ticket, Ticket, required: true
  attr :id, :string, required: true
  def ticket(assigns) do
    ~H"""
      <div id={@id} class="ticket">
        <span class="timline"></span>
      <section>
        <div class="price-paid">
          ${@ticket.price}
        </div>
        <div>
          <span class="username">
            {@ticket.user.username}
          </span>
          bought a ticket
          <blockquote>
            {@ticket.comment}
          </blockquote>
        </div>
      </section>
      </div>
    """
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
