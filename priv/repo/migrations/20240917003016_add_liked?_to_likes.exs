defmodule :"Elixir.Bloggy.Repo.Migrations.AddLiked?ToLikes" do
  use Ecto.Migration

  def change do
    alter table(:likes) do
      add :liked?, :boolean, default: false
    end
  end
end
