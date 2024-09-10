defmodule Bloggy.Repo.Migrations.AddDescriptionToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :description, :string, null: true
    end
  end
end
