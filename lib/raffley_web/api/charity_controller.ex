defmodule RaffleyWeb.Api.CharityController do
  use RaffleyWeb, :controller

  alias Raffley.Admin
  alias Raffley.Charities

  def show(conn, %{"raffle_id" => raffle_id}) do
    raffle = Admin.get_raffle!(raffle_id)
    charity = Charities.get_charity!(raffle.charity_id)
    render(conn, :show, charity: charity)

  rescue
    Ecto.NoResultsError ->
    conn
    |> put_status(:not_found)
    |> put_view(json: RaffleyWeb.ErrorJSON)
    |> render(:"404")
  end
end
