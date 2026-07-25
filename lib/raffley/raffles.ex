defmodule Raffley.Raffles do

  alias Raffley.Raffles.Raffle
  alias Raffley.Tickets
  alias Raffley.Charities.Charity
  alias Raffley.Repo

  import Ecto.Query

  def list_raffles do
    Repo.all(Raffle)
  end


  def filter_raffles(filter) do
    Raffle
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> with_charity(filter["charity"])
    |> sort(filter["sort_by"])
    |> preload(:charity)
    |> Repo.all()
  end

  defp with_charity(query, charity_slug) when charity_slug in ["", nil], do: query

  defp with_charity(query, charity_slug) do
    # from r in query,
    # join: c in Charity,
    # on: r.charity_id == c.id, where: c.slug == ^charity_slug

    from r in query,
      join: c in assoc(r, :charity),
      on: r.charity_id == c.id, where: c.slug == ^charity_slug
  end


  defp with_status(query, status) when status in ~w(open closed upcoming) do
    where(query, status: ^status)
  end

  defp with_status(query,_), do: query

  defp search_by(query, q) when q in ["", nil] , do: query

  defp search_by( query, q ) do
    where(query, [r], like(r.prize, ^"%#{q}%"))
  end

  defp sort(query, "prize"), do: order_by(query, asc: :prize)

  defp sort(query, "ticket_price"), do: order_by(query, asc: :ticket_price)

  defp sort(query, "-ticket_price"), do: order_by(query, desc: :ticket_price)

  defp sort(query, "charity") do
    from r in query,
      join: c in assoc(r, :charity),
      order_by: c.name
  end

  defp sort(query, _), do: query


  def get_raffle!(id) do
    Repo.get!(Raffle, id) |> Repo.preload(:charity)
  end

  def list_tickets(raffle) do
    raffle 
    |> Ecto.assoc(:tickets) 
    |> preload(:user) 
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end


  def featured_raffle(raffle) do
    Process.sleep(2000)
    Raffle
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> limit(3)
    |> Repo.all()
  end

end
