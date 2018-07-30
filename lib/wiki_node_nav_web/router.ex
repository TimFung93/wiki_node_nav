defmodule WikiNodeNavWeb.Router do
  use WikiNodeNavWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WikiNodeNavWeb do
    post "/compare", PageController, :post
  end
end
