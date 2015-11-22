defmodule WebSecurity.AuthPlug do
  use WebSecurity.Web, :plug

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    assign(conn, :user, user)
  end
end
