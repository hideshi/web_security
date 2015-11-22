defmodule WebSecurity.UserController do
  use WebSecurity.Web, :controller

  alias WebSecurity.User

  plug :scrub_params, "user" when action in [:create, :update]

  def login(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  def authenticate(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "top.html", changeset: changeset)
  end

  def logout(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  def register(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  def send_activation(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    #WebSecurity.Mailer.send_email("hideshi.ogoshi@gmail.com", "Registered your account", "Please activate now")
    case Repo.insert(changeset) do
      {:ok, %User{email: email}} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> render("sent_activation.html", changeset: changeset)
      {:error, changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def activate(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "activated.html", changeset: changeset)
  end

  def forgot_password(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "input_email.html", changeset: changeset)
  end

  def send_confirmation(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "sent_confirmation.html", changeset: changeset)
  end

#  def index(conn, _params) do
#    users = Repo.all(User)
#    render(conn, "index.html", users: users)
#  end
#
#  def new(conn, _params) do
#    changeset = User.changeset(%User{})
#    render(conn, "new.html", changeset: changeset)
#  end
#
#  def create(conn, %{"user" => user_params}) do
#    changeset = User.changeset(%User{}, user_params)
#
#    case Repo.insert(changeset) do
#      {:ok, _user} ->
#        conn
#        |> put_flash(:info, "User created successfully.")
#        |> redirect(to: user_path(conn, :index))
#      {:error, changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end
#  end
#
#  def show(conn, %{"id" => id}) do
#    user = Repo.get!(User, id)
#    render(conn, "show.html", user: user)
#  end
#
#  def edit(conn, %{"id" => id}) do
#    user = Repo.get!(User, id)
#    changeset = User.changeset(user)
#    render(conn, "edit.html", user: user, changeset: changeset)
#  end
#
#  def update(conn, %{"id" => id, "user" => user_params}) do
#    user = Repo.get!(User, id)
#    changeset = User.changeset(user, user_params)
#
#    case Repo.update(changeset) do
#      {:ok, user} ->
#        conn
#        |> put_flash(:info, "User updated successfully.")
#        |> redirect(to: user_path(conn, :show, user))
#      {:error, changeset} ->
#        render(conn, "edit.html", user: user, changeset: changeset)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    user = Repo.get!(User, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(user)
#
#    conn
#    |> put_flash(:info, "User deleted successfully.")
#    |> redirect(to: user_path(conn, :index))
#  end
end
