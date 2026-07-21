defmodule RaffleyWeb.Api.CharityJSON do

  def index(%{ charities: charities }) do
    %{
      charities:
      for(
        charity <- charities,
        do: data(charity)
      )
    }
  end

  def show(%{charity: charity}) do
    %{
      charity: data(charity)    }
  end

  defp data(charity) do
    %{
        id: charity.id,
        name: charity.name,
        slug: charity.slug
      }
  end
end
