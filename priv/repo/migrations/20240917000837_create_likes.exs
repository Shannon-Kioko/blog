defmodule Bloggy.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :count, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end

    create index(:likes, [:user_id])
    create index(:likes, [:post_id])
  end
end
