defmodule WebSecurity.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :is_active, :boolean, default: false
      add :registration_limit, :datetime
      add :login_error, :integer, default: 0
      add :login_denial_limit, :datetime
      add :onetime_token, :string

      timestamps
    end
    create unique_index(:users, [:name])
    create unique_index(:users, [:email])
  end
end
