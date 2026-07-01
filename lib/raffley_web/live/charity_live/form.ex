defmodule RaffleyWeb.CharityLive.Form do
  use RaffleyWeb, :live_view

  alias Raffley.Charities.Charity
  alias Raffley.Charities

  import RaffleyWeb.CharityLive.FormComponent

  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :new, _params) do
    socket =
      socket
      |> assign(:charity, %Charity{})
    socket
  end

  def apply_action(socket, :edit, %{"id" => id}) do
    charity = Charities.get_charity!(id)
    socket =
      socket
      |> assign(:charity, charity)
    socket
  end


  def render(assigns) do
    ~H"""
    <div id="my-div">
      <.live_component
        module={RaffleyWeb.CharityLive.FormComponent}
        id="charity-form"
        title="New Charity"
        action={@live_action}
        charity={@charity}
        patch={~p"/charities"}
      />
    </div>
    """
  end
end
