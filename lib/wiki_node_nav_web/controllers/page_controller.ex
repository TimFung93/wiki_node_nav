defmodule WikiNodeNavWeb.PageController do
  use WikiNodeNavWeb, :controller
  alias Wiki

  def post(conn, params) do
    Wiki.get_links(params)

    receive do
      result ->
        require IEx
        IEx.pry
    end

  end
end
