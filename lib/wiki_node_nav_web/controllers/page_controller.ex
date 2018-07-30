defmodule WikiNodeNavWeb.PageController do
  use WikiNodeNavWeb, :controller
  alias Wiki

  def index(conn, _params) do
    render conn, "index.html"
  end

  def post(conn, params), do: Wiki.get_links(params)
end
