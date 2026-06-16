defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  alias Raffley.Rules
  plug :set_title

  def index(conn, _params) do
    emoji = ~w("😀 😃 😄 😁 😆) |> Enum.random()

    rules = Rules.list_rules()
    render(conn, :index, emoji: emoji, rules: rules)
  end

  def show(conn, %{"id" => id}) do
    rule = Rules.get_rule(id)
    render(conn, :show, rule: rule)
  end

  defp set_title(conn, _opts) do
    conn
    |> assign(:page_title, "Raffle Rules")
  end
end 
