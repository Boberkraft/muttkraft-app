defmodule MuttkraftWeb.Router do
  use MuttkraftWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MuttkraftWeb do
    pipe_through [:browser, :maybe_authenticate_user]

    get "/", PageController, :index

    scope "/app", MuttkraftWeb do
      pipe_through [:authenticate_user]
      get "/hello", HelloController, :index
      get "/hello/:messenger", HelloController, :show
    end

    resources "/sessions", SessionController,
      only: [:new, :create, :delete],
      singleton: true
    resources "/villages", VillageController
    resources "/buildings", BuildingController
    
    resources "/users", UserController do
      get "/become", UserController, :become
    end
  end

  defp maybe_authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
      user_id -> 
        assign(conn, :current_user, Muttkraft.Accounts.get_user!(user_id))
    end
  end
  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()
      user_id ->
        assign(conn, :current_user, Muttkraft.Accounts.get_user!(user_id))
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MuttkraftWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MuttkraftWeb.Telemetry
    end
  end
end
