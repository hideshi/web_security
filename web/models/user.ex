defmodule WebSecurity.User do
  use WebSecurity.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :is_in_registration, :boolean, default: true
    field :registration_limit, Ecto.DateTime
    field :is_active, :boolean, default: false
    field :login_error, :integer, default: 0
    field :login_denial_limit, Ecto.DateTime
    field :onetime_token, :string

    timestamps
  end

  @required_fields ~w(name email password)
  @optional_fields ~w(is_in_registration registration_limit is_active login_error login_denial_limit onetime_token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 8)
    |> validate_length(:name, max: 24)
    |> validate_format(:name, ~r/[A-Za-z0-9_]/)
    |> validate_format(:email, ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/)
    |> validate_length(:password, min: 8)
    |> validate_length(:password, max: 100)
    |> validate_format(:password, ~r/[A-Za-z0-9!#\$%&\\\{\}\[\]_\.\^\*':\(\)\+\?;"=,~<>\|]/)
    |> unique_constraint(:name)
    |> unique_constraint(:email)
  end

  before_insert :hash_password
  before_update :hash_password
  def hash_password(changeset) do
    password_hash = changeset
    |> Ecto.Changeset.get_field(:password)
    |> Comeonin.Bcrypt.hashpwsalt()
    Ecto.Changeset.put_change(changeset, :password_hash, password_hash)
  end
end
