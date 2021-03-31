defmodule MuttkraftWeb.PageController do
  use MuttkraftWeb, :controller

  def index(conn, _params) do
    villages = Muttkraft.Map.list_villages()
    render(conn, "index.html", villages: villages)
  end
end
