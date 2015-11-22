defmodule WebSecurity.Router do
  use WebSecurity.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AuthPlug, repo: Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WebSecurity do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    #resources "/users", UserController
    get "/users/login", UserController, :login
    post "/users/authenticate", UserController, :authenticate
    get "/users/logout", UserController, :logout
    get "/users/register", UserController, :register
    post "/users/send_activation", UserController, :send_activation
    get "/users/activate/:token", UserController, :activate
    get "/users/forgot_password", UserController, :forgot_password
    post "/users/send_confirmation", UserController, :send_confirmation
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebSecurity do
  #   pipe_through :api
  # end
end
