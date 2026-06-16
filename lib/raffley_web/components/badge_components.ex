defmodule RaffleyWeb.Components.BadgeComponents do
  use Phoenix.Component


  attr :status, :string, required: true
  attr :class, :string, default: nil


  def badge(assigns) do
    ~H"""
    <div class={["rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :open && " text-lime-600 border-lime-600", 
      @status == :upcoming && " text-amber-600 border-amber-600", 
      @status == :closed && " text-gray-600 border-gray-600", 
    @class]}>
      {@status}
    </div>
    """
  end

end
