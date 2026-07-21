defmodule RaffleyWeb.Api.CharityJSON do
  def show(%{charity: charity}) do
    %{
      charity: %{
        name: charity.name,
        slug: charity.slug
      }
    }
  end
end
