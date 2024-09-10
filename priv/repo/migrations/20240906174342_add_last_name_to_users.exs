defmodule Bloggy.Repo.Migrations.AddLastNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone, :citext, null: true
      add :first_name, :citext, null: true
      add :last_name, :citext, null: true
    end
  end
end
