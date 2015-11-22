defmodule WebSecurity.UserController do
  use WebSecurity.Web, :controller

  alias WebSecurity.User
  alias WebSecurity.Mailer

  plug :scrub_params, "user" when action in [:create, :update]

  def login(conn, _params) do
    changeset = User.login_changeset(%User{})
    render(conn, "login.html", changeset: changeset)
  end

  def authenticate(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{}, user_params)
    case changeset do
      %Ecto.Changeset{valid?: false} ->
        conn
        |> put_flash(:error, "Failed user authentication.")
        |> redirect(to: user_path(conn, :login))
      _ ->
        conn
        |> put_flash(:info, "User authenticated successfully.")
        |> redirect(to: user_path(conn, :login))
    end
  end

  def logout(conn, _params) do
    conn
    |> redirect(to: user_path(conn, :login))
  end

  def register(conn, _params) do
    changeset = User.registration_changeset(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  def send_activation(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, %User{email: email}} ->
        case Mailer.send_email("hideshi.ogoshi@gmail.com", "Registered your account", "Please activate now") do
          {:ok, status} ->
            conn
            |> put_flash(:info, "Email have sent successfully.")
            |> render("sent_activation.html", changeset: changeset)
          _ ->
            conn
            |> put_flash(:error, "Email haven't sent because of error.")
            |> render("sent_activation.html", changeset: changeset)
        end
      {:error, changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def activate(conn, _params) do
    render(conn, "activated.html")
  end

  def forgot_password(conn, _params) do
    changeset = User.email_changeset(%User{})
    render(conn, "input_email.html", changeset: changeset)
  end

  def send_confirmation(conn, %{"user" => user_params}) do
    changeset = User.email_changeset(%User{}, user_params)
    render(conn, "sent_confirmation.html")
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
