defmodule Bloggy.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    # Add indexes for efficient lookup
    create index(:comments, [:post_id])
    create index(:comments, [:user_id])
  end
end
