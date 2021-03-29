defmodule MuttkraftWeb.PageController do
  use MuttkraftWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
