defmodule WebSecurity.User do
  use WebSecurity.Web, :model
  use Timex

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :is_active, :boolean, default: false
    field :registration_limit, Ecto.DateTime
    field :login_error, :integer, default: 0
    field :login_denial_limit, Ecto.DateTime
    field :onetime_token, :string

    timestamps
  end

  @required_fields ~w(name email password password_confirmation)
  @optional_fields ~w(is_active registration_limit login_error login_denial_limit onetime_token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def login_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name password), [])
    |> validate_length(:name, min: 8)
    |> validate_length(:name, max: 24)
    |> validate_format(:name, ~r/[A-Za-z0-9_]/)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 100)
    |> validate_format(:password, ~r/[A-Za-z0-9!#\$%&\\\{\}\[\]_\.\^\*':\(\)\+\?;"=,~<>\|]/)
    #|> authenticate
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 8)
    |> validate_length(:name, max: 24)
    |> validate_format(:name, ~r/[A-Za-z0-9_]/)
    |> validate_format(:email, ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 100)
    |> validate_format(:password, ~r/[A-Za-z0-9!#\$%&\\\{\}\[\]_\.\^\*':\(\)\+\?;"=,~<>\|]/)
    |> validate_confirmation(:password)
    |> unique_constraint(:name)
    |> unique_constraint(:email)
    |> set_registration_limit
    |> hash_password
  end

  def email_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/)
  end

  def password_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 100)
    |> validate_format(:password, ~r/[A-Za-z0-9!#\$%&\\\{\}\[\]_\.\^\*':\(\)\+\?;"=,~<>\|]/)
    |> validate_confirmation(:password)
    |> hash_password
  end

  def authenticate(changeset) do
#    case changeset do
#      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
#        query = from u in User,
#          where: u.name == name,
#          select: count(u.id)
#
#        case Repo.one(query) do
#          1 -> changeset
#          _ -> add_error(changeset, :error, "User doesn't exist.")
#        end
#      _ -> changeset
#    end
  end

  def set_registration_limit(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} -> put_change(changeset, :registration_limit, Date.now |> Date.shift(days: 1) |> DateConvert.to_erlang_datetime |> Ecto.DateTime.from_erl)
      _ -> changeset
    end
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} -> put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ -> changeset
    end
  end
end
