defmodule RaffleyWeb.Api.CharityController do
  use RaffleyWeb, :controller

  alias Raffley.Admin
  alias Raffley.Charities

  def index(conn, _params) do
    render(conn, :index, charities: Charities.list_charities)
  end

  def show(conn, %{"raffle_id" => raffle_id}) do
    raffle = Admin.get_raffle!(raffle_id)
    charity = Charities.get_charity!(raffle.charity_id)
    render(conn, :show, charity: charity)
  rescue
    Ecto.NoResultsError ->
    not_found(conn)
  end

  def show(conn, %{"id" => id}) do
    charity = Charities.get_charity!(id)
    render(conn, :show, charity: charity)
  rescue
    Ecto.NoResultsError ->
    not_found(conn)
  end

  defp not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(json: RaffleyWeb.ErrorJSON)
    |> render(:"404")
  end
end
