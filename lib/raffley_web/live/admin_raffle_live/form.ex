defmodule RaffleyWeb.AdminRaffleLive.Form do
  use RaffleyWeb, :live_view

  alias Raffley.Admin
  alias Raffley.Raffles.Raffle

  def mount(params, _session, socket) do
  {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    raffle = %Raffle{}
    changeset = Admin.change_raffle(raffle)
    socket = 
      socket
      |> assign(:page_title, "New Raffle")
      |> assign(:form, to_form(changeset))
      |> assign(:raffle, raffle)
    socket
  end


  defp apply_action(socket, :edit, %{"id" => id}) do
    raffle = Admin.get_raffle!(id)
    changeset = Admin.change_raffle(raffle)
    socket =  socket
      |> assign(:page_title, "Edit Raffle")
      |> assign(:form, to_form(changeset))
      |> assign(:raffle, raffle)
    socket
  end

  def render(assigns) do 
    ~H"""
    <.header>
      <%= @page_title  %>
    </.header>
    <.simple_form for={@form} id="raffle-form" phx-submit="save" phx-change="validate">
      <.input
        field={@form[:prize]}
        label="Prize"
        phx-debounce="blur"
      />
      <.input
        type="textarea"
        field={@form[:description]}
        label="Description"
        phx-debounce="blur"
      />
      <.input
        type="number"
        field={@form[:ticket_price]}
        label="Ticket Price"
      />
      <.input
        type="select"
        field={@form[:status]}
        label="Status"
        prompt="Choose a status"
        options={["Upcoming": "upcoming" ,"Open": "open", "Closed": "closed"]}
        required
      />

      <.input
        type="text"
        field={@form[:image_path]}
        label="Image Path"
      />
      <:actions>
        <.button type="submit" phx-disable-with="Saving...">Save Raffle</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/raffles"} >
      Back
    </.back>
    """
  end

  def handle_event("validate", %{"raffle" => raffle_params}, socket) do
    changeset = Admin.change_raffle(socket.assigns.raffle, raffle_params)
    socket = assign(socket, :form, to_form(changeset, action: "valid"))
    {:noreply, socket}
  end

  def handle_event("save", %{"raffle" => raffle_params}, socket) do
    save_raffle(socket, socket.assigns.live_action, raffle_params)
  end

  defp save_raffle(socket, :new, raffle_params) do 
    case Admin.create_raffle(raffle_params) do
      {:ok, _raffle} ->
      socket = 
        socket 
        |> put_flash(:info, "Raffle created successfully.")
        |> push_navigate(to: ~p"/admin/raffles")
      {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
      socket = 
        socket
        |> put_flash(:error, "Failed to create raffle.")
        |> assign(:form, to_form(changeset))
        IO.puts "Error creating raffle: #{inspect(changeset)}"
        {:noreply, socket}
    end

  end

  defp save_raffle(socket, :edit, raffle_params )  do 
    raffle = socket.assigns.raffle
    
    case Admin.update_raffle(raffle, raffle_params) do
      {:ok, _raffle} ->
        socket = 
          socket 
          |> put_flash(:info, "Raffle updated successfully.")
          |> push_navigate(to: ~p"/admin/raffles")
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        socket = 
          socket
          |> put_flash(:error, "Failed to update raffle.")
          |> assign(:form, to_form(changeset))
        IO.puts "Error updating raffle: #{inspect(changeset)}"
        {:noreply, socket}
    end
  end

end

