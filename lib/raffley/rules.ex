defmodule Raffley.Rules do

  def list_rules do
    [
      %{
        id: 1,
        text: "Participants must have a high level of enthusiasm and energy.",
      },
      %{
        id: 2,
        text: "All actions must be performed with a sense of humor and fun.",
      },
      %{
        id: 3,
        text: "Participants must be willing to take risks and try new things.",
      }
    ]
  end

  def get_rule(id) when is_integer(id) do
    Enum.find(list_rules(), fn rule -> rule.id == id end)
  end

  def get_rule(id) when is_binary(id) do
    id |> String.to_integer() |> get_rule()
  end
end
